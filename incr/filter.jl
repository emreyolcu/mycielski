function main(args)
    solfile = args[1]
    nvar = parse(Int, args[2])
    nsol = parse(Int, args[3])
    cnffile = args[4]

    i = 1
    sol = BitArray(undef, nsol, nvar)
    fill!(sol, 0)
    open(solfile) do file
        for line in eachline(file)
            if i > nsol
                break
            end
            sol[i, :] = [parse(Int, x) > 0 for x in split(line)[1:(end - 1)]]
            i += 1
        end
    end

    vig = zeros(Int8, nvar, nvar)
    open(cnffile) do file
        for line in eachline(file)
            if startswith(line, "p") || startswith(line, "c")
                continue
            end
            vars = [abs(parse(Int, x)) for x in split(line)[1:(end - 1)]]
            for i in vars
                for j in vars
                    vig[i, j] = 1
                end
            end
        end
    end

    pairs = []
    for i = 1:(nvar - 1)
        for j = (i + 1):nvar
            if vig[i, j] == 1
                continue
            end

            # pos, pos
            pass = false
            for k = 1:nsol
                if (sol[k, i] == 1) && (sol[k, j] == 1)
                    pass = true
                    break
                end
            end
            if !pass
                push!(pairs, (i, j))
            end

            # neg, pos
            pass = false
            for k = 1:nsol
                if (sol[k, i] == 0) && (sol[k, j] == 1)
                    pass = true
                    break
                end
            end
            if !pass
                push!(pairs, (-i, j))
            end
            
            # pos, neg
            pass = false
            for k = 1:nsol
                if (sol[k, i] == 1) && (sol[k, j] == 0)
                    pass = true
                    break
                end
            end
            if !pass
                push!(pairs, (i, -j))
            end

            # neg, neg
            pass = false
            for k = 1:nsol
                if (sol[k, i] == 0) && (sol[k, j] == 0)
                    pass = true
                    break
                end
            end
            if !pass
                push!(pairs, (-i, -j))
            end
        end
    end

    for (i, j) in pairs
        println("a $i $j 0")
    end
end

main(ARGS)
