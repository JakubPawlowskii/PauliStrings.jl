using PauliStrings
import PauliStrings as ps
using Printf

function XXZ(N, J, Δ)
    H = ps.Operator(N)
    for i in 1:N
        H += J, "X", i, "X", mod1(i + 1, N)
        H += J, "Y", i, "Y", mod1(i + 1, N)
        H += J * Δ, "Z", i, "Z", mod1(i + 1, N)
    end
    return ps.OperatorTS1D(H, full=true)
end


M = 6
L = 2 * M + 1

support = ps.k_local_basis(L, M; translational_symmetry=true)
println("Size of basis: $(length(support))")
H = XXZ(L, 1.0, 0.5)
evals, ops = ps.lioms(H, support; return_all=false)

for i in eachindex(evals)
    @printf("Eigenvalue %2d: %1.5e\n", i, evals[i])
    @printf("||[H, O]|| = %1.5e\n", ps.opnorm(ps.commutator(H, ops[i]), normalize=true))
    println()
end

println("Number of LIOMs found: ", count(x -> abs(x) < 1e-10, evals))