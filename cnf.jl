function mycielgraph(k)
    E = [(1, 2)]
    n = 2
    for i = 3:k
        m = length(E)
        for (x, y) in E[1:m]
            push!(E, (x + n, y))
            push!(E, (x, y + n))
        end
        for x = (n + 1):2n
            push!(E, (x, 2n + 1))
        end
        n = 2n + 1
    end
    return (E, n)
end

function graphtocnf(G, k)
    clauses = []
    E, n = G
    index(i, c) = (i-1) * k + c
    for i = 1:n
        push!(clauses, (i-1) * k .+ collect(1:k))
    end
    for (x, y) in E
        for c = 1:k
            push!(clauses, [-index(x, c), -index(y, c)])
        end
    end
    return clauses
end

function writecnf(n, clauses, filename)
    open(filename, "w") do f
        write(f, "p cnf $n $(length(clauses))\n")
        for c in clauses
            write(f, join(c, " ") * " 0\n")
        end
    end
end

function main()
    for k = 3:10
        G = mycielgraph(k)
        writecnf(G[2] * (k-1), graphtocnf(G, k-1), "cnf/M$k.cnf")
        writecnf(G[2] * k, graphtocnf(G, k), "cnf/M$k+.cnf")
    end
end

main()
