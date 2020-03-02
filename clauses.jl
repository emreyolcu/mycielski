function graph(m)
    global nv, edges, cross, w_edges
    if m < 2
        println("tried to generate graph smaller than 2")
    elseif m == 2
        push!(edges[2], (1, 2))
        nv[2] = 2
    else
        graph(m - 1)
        es = edges[m - 1]
        v = nv[m - 1]
        edges[m] = deepcopy(es)
        for i = 1:v
            for e in es
                if e[1] == i
                    push!(edges[m], (i, e[2] + v))
                    push!(cross[m], (i, e[2] + v))
                end
                if e[2] == i
                    push!(edges[m], (e[1] + v, i))
                    push!(cross[m], (e[1] + v, i))
                end
            end
        end
        w = 2v + 1
        for i = (v + 1):2v
            push!(edges[m], (i, w))
        end
        for e in w_edges[m - 1]
            push!(w_edges[m], (e[1] + v, e[2] + v))
        end
        for i = (v + 1):2v
            push!(w_edges[m], (i, w))
        end
        nv[m] = w
    end
end

function index(i, c)
    global nc
    return (i-1) * nc + c
end

function addblocked(m)
    for i in 1:nv[m]
        for c in 1:nc
            for d in (c + 1):nc
                println("-$(index(i, c)) -$(index(i, d)) 0")
            end
        end
    end
end

function addtemp(m)
    v = nv[m - 1]
    s = 0
    for i = m:(k - 1)
        s += nv[i]
    end
    w = nv[m] + s

    if "pr" in clauses
        for i = (s + 1):(s + v)
            for c = 1:nc
                for d = 1:nc
                    if c == d
                        continue
                    end
                    push!(delete[m], ((-index(v + i, d), -index(i, c), index(w, c)), (-index(v + i, d), index(v + i, c), index(i, c), -index(w, c))))
                end
            end
        end
    end

    if "rup1" in clauses
        for e in edges[m - 1]
            for c = 1:nc
                for d = 1:nc
                    if c == d
                        continue
                    end
                    push!(delete[m], ((-index(e[1] + s + v, c), -index(e[2] + s + v, c), -index(e[1] + s, d)), ()))
                end
            end
        end
    end

    for cl in delete[m]
        println(join(cl[1], " ") * " 0")
    end
end

function addedges(m)
    v = nv[m - 1]
    for i = m:(k - 1)
        v += nv[i]
    end
    for e in edges[m - 1]
        for c in 1:nc
            println("-$(index(e[1] + v, c)) -$(index(e[2] + v, c)) 0")
        end
    end
end

function proof(m)
    global k, clauses
    if m < 2
        println("proof < 2")
    elseif m == 2
        # addclique(k)
    else
        addtemp(m)
        if "rup2" in clauses
            addedges(m)
        end
        proof(m - 1)
    end
end

function main(args)
    global k, nc, nv, edges, cross, w_edges, delete, clauses

    k = parse(Int, args[1])
    nc = parse(Int, args[2])
    clauses = split(args[3], ',')

    nv = zeros(Int, k)

    edges = [[] for _ = 1:k]
    cross = [[] for _ = 1:k]
    w_edges = [[] for _ = 1:k]
    delete = [[] for _ = 1:k]

    graph(k)
    if "bc" in clauses
        addblocked(k)
    end
    proof(k)
end

main(ARGS)
