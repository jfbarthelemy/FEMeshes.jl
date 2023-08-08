function mesh_square(filename, a, dens ; order=1)
    """
            NORTH
        P4-----------P3
        |             |
        |             |
 WEST   |             |  EAST
        |             |
        |             |
        P1-----------P2
            SOUTH

    """
    gmsh.initialize()
    model = gmsh.model
    factory = model.geo
    gmsh.option.setNumber("General.Terminal", 1)
    gmsh.option.setNumber("General.Verbosity", 0)
    # gmsh.option.setNumber("Mesh.MshFileVersion", 2)
    model.mesh.setOrder(order)
    gmsh.option.setNumber("Mesh.ElementOrder", order)
    gmsh.option.setNumber("Mesh.HighOrderOptimize", order)
    gmsh.option.setNumber("Mesh.SecondOrderLinear", 0)
    model.add(filename)

    P1 = factory.addPoint(0,0,0,dens)
    model.addPhysicalGroup(0, [P1], -1, "P1")
    P2 = factory.addPoint(a,0,0,dens)
    model.addPhysicalGroup(0, [P2], -1, "P2")
    P3 = factory.addPoint(a,a,0,dens)
    model.addPhysicalGroup(0, [P3], -1, "P3")
    P4 = factory.addPoint(0,a,0,dens)
    model.addPhysicalGroup(0, [P4], -1, "P4")
    SOUTH = factory.addLine(P1,P2)
    model.addPhysicalGroup(1,[SOUTH], -1, "SOUTH")
    EAST = factory.addLine(P2,P3)
    model.addPhysicalGroup(1,[EAST], -1, "EAST")
    NORTH = factory.addLine(P3,P4)
    model.addPhysicalGroup(1,[NORTH], -1, "NORTH")
    WEST = factory.addLine(P4,P1)
    model.addPhysicalGroup(1,[WEST], -1, "WEST")
    ll=factory.addCurveLoop([SOUTH,EAST,NORTH,WEST])
    S = factory.addPlaneSurface([ll])
    model.addPhysicalGroup(2,[S], -1, "SQUARE")

    factory.synchronize()
    gmsh.write(filename*".geo_unrolled")
    
    model.mesh.generate(2)
    gmsh.write(filename*".msh")
    gmsh.finalize()
end

function mesh_cube(filename, a, dens ; order=1)
    """
                NORTH
                /  
            Q4------Q3 
          /|       /|
         / | TOP  / |
        Q1------Q2 EAST
        |  |     |  |  
    WEST|  P4----|-P3
        | /BOTTOM| /
        |/       |/
        P1--/---P2 
            SOUTH
    
    """
    gmsh.initialize()
    model = gmsh.model
    factory = model.geo
    gmsh.option.setNumber("General.Terminal", 1)
    gmsh.option.setNumber("General.Verbosity", 0)
    # gmsh.option.setNumber("Mesh.MshFileVersion", 2)
    model.mesh.setOrder(order)
    gmsh.option.setNumber("Mesh.ElementOrder", order)
    gmsh.option.setNumber("Mesh.HighOrderOptimize", order)
    gmsh.option.setNumber("Mesh.SecondOrderLinear", 0)
    model.add(filename)

    P1 = factory.addPoint(0,0,0,dens)
    model.addPhysicalGroup(0, [P1], -1, "P1")
    P2 = factory.addPoint(a,0,0,dens)
    model.addPhysicalGroup(0, [P2], -1, "P2")
    P3 = factory.addPoint(a,a,0,dens)
    model.addPhysicalGroup(0, [P3], -1, "P3")
    P4 = factory.addPoint(0,a,0,dens)
    model.addPhysicalGroup(0, [P4], -1, "P4")

    Q1 = factory.addPoint(0,0,a,dens)
    model.addPhysicalGroup(0, [Q1], -1, "Q1")
    Q2 = factory.addPoint(a,0,a,dens)
    model.addPhysicalGroup(0, [Q2], -1, "Q2")
    Q3 = factory.addPoint(a,a,a,dens)
    model.addPhysicalGroup(0, [Q3], -1, "Q3")
    Q4 = factory.addPoint(0,a,a,dens)
    model.addPhysicalGroup(0, [Q4], -1, "Q4")

    P1P2 = factory.addLine(P1,P2)
    model.addPhysicalGroup(1,[P1P2], -1, "P1P2")
    P2P3 = factory.addLine(P2,P3)
    model.addPhysicalGroup(1,[P2P3], -1, "P2P3")
    P3P4 = factory.addLine(P3,P4)
    model.addPhysicalGroup(1,[P3P4], -1, "P3P4")
    P4P1 = factory.addLine(P4,P1)
    model.addPhysicalGroup(1,[P4P1], -1, "P4P1")

    Q1Q2 = factory.addLine(Q1,Q2)
    model.addPhysicalGroup(1,[Q1Q2], -1, "Q1Q2")
    Q2Q3 = factory.addLine(Q2,Q3)
    model.addPhysicalGroup(1,[Q2Q3], -1, "Q2Q3")
    Q3Q4 = factory.addLine(Q3,Q4)
    model.addPhysicalGroup(1,[Q3Q4], -1, "Q3Q4")
    Q4Q1 = factory.addLine(Q4,Q1)
    model.addPhysicalGroup(1,[Q4Q1], -1, "Q4Q1")

    P1Q1 = factory.addLine(P1,Q1)
    model.addPhysicalGroup(1,[P1Q1], -1, "P1Q1")
    P2Q2 = factory.addLine(P2,Q2)
    model.addPhysicalGroup(1,[P2Q2], -1, "P2Q2")
    P3Q3 = factory.addLine(P3,Q3)
    model.addPhysicalGroup(1,[P3Q3], -1, "P3Q3")
    P4Q4 = factory.addLine(P4,Q4)
    model.addPhysicalGroup(1,[P4Q4], -1, "P4Q4")

    ll=factory.addCurveLoop([-P3P4,-P2P3,-P1P2,-P4P1])
    BOTTOM = factory.addPlaneSurface([ll])
    model.addPhysicalGroup(2,[BOTTOM], -1, "BOTTOM")

    ll=factory.addCurveLoop([Q1Q2,Q2Q3,Q3Q4,Q4Q1])
    TOP = factory.addPlaneSurface([ll])
    model.addPhysicalGroup(2,[TOP], -1, "TOP")

    ll=factory.addCurveLoop([P1P2,P2Q2,-Q1Q2,-P1Q1])
    SOUTH = factory.addPlaneSurface([ll])
    model.addPhysicalGroup(2,[SOUTH], -1, "SOUTH")

    ll=factory.addCurveLoop([P2P3,P3Q3,-Q2Q3,-P2Q2])
    EAST = factory.addPlaneSurface([ll])
    model.addPhysicalGroup(2,[EAST], -1, "EAST")

    ll=factory.addCurveLoop([P3P4,P4Q4,-Q3Q4,-P3Q3])
    NORTH = factory.addPlaneSurface([ll])
    model.addPhysicalGroup(2,[NORTH], -1, "NORTH")

    ll=factory.addCurveLoop([P4P1,P1Q1,-Q4Q1,-P4Q4])
    WEST = factory.addPlaneSurface([ll])
    model.addPhysicalGroup(2,[WEST], -1, "WEST")

    lS = factory.addSurfaceLoop([BOTTOM,SOUTH,EAST,NORTH,WEST,TOP])
    V = factory.addVolume([lS])

    model.addPhysicalGroup(3,[V], -1, "CUBE")

    factory.synchronize()
    gmsh.write(filename*".geo_unrolled")
    
    model.mesh.generate(3)
    gmsh.write(filename*".msh")
    gmsh.finalize()
end

function mesh_nlayer_ellipse(filename, radius_a, radius_b, dens_a, dens_b, dens_center ; core=true, order=1)
    gmsh.initialize()
    model = gmsh.model
    factory = model.geo
    gmsh.option.setNumber("General.Terminal", 1)
    gmsh.option.setNumber("General.Verbosity", 0)
    # gmsh.option.setNumber("Mesh.MshFileVersion", 2)
    model.mesh.setOrder(order)
    gmsh.option.setNumber("Mesh.ElementOrder", order)
    gmsh.option.setNumber("Mesh.HighOrderOptimize", order)
    gmsh.option.setNumber("Mesh.SecondOrderLinear", 0)
    model.add(filename)
    n=length(radius_a)
    O=factory.addPoint(0.,0.,0.,dens_center)
    inc=1 ; A=[] ; B=[] ; AB=[] ; AA=[] ; BB=[] ; S=[]
    for i in 1:n
        a=radius_a[i] ; b=radius_b[i]
        da=dens_a[i] ; db=dens_b[i]
        push!(A,factory.addPoint(a,0.,0.,da))
        model.addPhysicalGroup(0, [A[end]], -1, "A$(inc)")
        push!(B,factory.addPoint(0.,b,0.,db))
        model.addPhysicalGroup(0, [B[end]], -1, "B$(inc)")
        M = a>=b ?  A[end] : B[end]
        push!(AB,factory.addEllipseArc(A[end],O,M,B[end]))
        if inc==1
            if core
                model.addPhysicalGroup(0, [O], -1, "O")
                push!(AA,factory.addLine(O,A[end]))
                model.addPhysicalGroup(1,[AA[end]], -1, "0A1")
                push!(BB,factory.addLine(O,B[end]))
                model.addPhysicalGroup(1,[BB[end]], -1, "0B1")
                ll=factory.addCurveLoop([AA[end],AB[end],-BB[end]])
                push!(S,factory.addPlaneSurface([ll]))
                model.addPhysicalGroup(2,[S[end]], -1, "LAYER1")
            end
        else
            push!(AA,factory.addLine(A[end-1],A[end]))
            model.addPhysicalGroup(1,[AA[end]], -1, "A$(inc-1)A$(inc)")
            push!(BB,factory.addLine(B[end-1],B[end]))
            model.addPhysicalGroup(1,[BB[end]], -1, "B$(inc-1)B$(inc)")
            ll=factory.addCurveLoop([AA[end],AB[end],-BB[end],-AB[end-1]])
            push!(S,factory.addPlaneSurface([ll]))
            model.addPhysicalGroup(2,[S[end]], -1, "LAYER$(inc)")
        end
        model.addPhysicalGroup(1,[AB[end]], -1, "BOUND$(inc)")
        inc+=1
    end
            
    factory.synchronize()
    gmsh.write(filename*".geo_unrolled")
    
    model.mesh.generate(2)
    gmsh.write(filename*".msh")
    gmsh.finalize()
end

function mesh_hole_square(filename, l, D, R, d₁, d₂; order = 1 )
    """
                        NORTH
            P4__________________________P3  ^
            |                           |   |
       WEST |                           |   |
            |                           |   |
            |                           |   |
        ^ PF.                           |   |     EAST
       l|   .                           |   | D
        v P5.                           |   |
                °                       |   |
              /    °                    |   |
        R    /       °                  |   |
            /         °_________________P2  v
                    P1      SOUTH           

    """
    gmsh.initialize()
    model = gmsh.model
    factory = model.geo
    gmsh.option.setNumber("General.Terminal", 1)
    gmsh.option.setNumber("General.Verbosity", 0)
    model.mesh.setOrder(order)
    gmsh.option.setNumber("Mesh.ElementOrder", order) 
    gmsh.option.setNumber("Mesh.HighOrderOptimize", order)
    gmsh.option.setNumber("Mesh.SecondOrderLinear", 0)
    model.add(filename)

    p = []
    push!(p,factory.addPoint(R, 0., 0., d₁))
    push!(p,factory.addPoint(D, 0., 0., d₁))
    push!(p,factory.addPoint(D, D, 0., d₁))
    push!(p,factory.addPoint(0., D, 0., d₁))
    push!(p,factory.addPoint(0., R+l, 0., d₂))
    push!(p,factory.addPoint(0., R, 0., d₂))
    push!(p,factory.addPoint(0., 0., 0., d₁))

    li = []
    for i in 1:5 
        push!(li,factory.addLine(p[i],p[i+1]))
    end
    push!(li,factory.addEllipseArc(p[6],p[7],p[6],p[1]))

    ll=factory.addCurveLoop(li)
    s=factory.addPlaneSurface([ll])

    factory.synchronize()

    model.addPhysicalGroup(0,[p[begin]],-1,"P1")
    model.addPhysicalGroup(0,[p[2]],-1,"P2")
    model.addPhysicalGroup(0,[p[3]],-1,"P3")
    model.addPhysicalGroup(0,[p[4]],-1,"P4")
    model.addPhysicalGroup(0,[p[5]],-1,"PF")

    model.addPhysicalGroup(1,[li[begin]],-1,"SOUTH")
    model.addPhysicalGroup(1,[li[3]],-1,"NORTH")
    model.addPhysicalGroup(1,[li[4]],-1,"WEST")
    model.addPhysicalGroup(2,[s],-1,"Omega")

    #geom.synchronize()

    gmsh.model.mesh.field.add("Distance", 1)
    gmsh.model.mesh.field.setNumbers(1, "PointsList",[p[5],p[6]])
    gmsh.model.mesh.field.setNumber(1, "Sampling", 100)

    gmsh.model.mesh.field.add("Threshold", 2)
    gmsh.model.mesh.field.setNumber(2, "InField", 1)
    gmsh.model.mesh.field.setNumber(2, "Sigmoid", 1)

    gmsh.model.mesh.field.setNumber(2, "LcMin", d₂)
    gmsh.model.mesh.field.setNumber(2, "LcMax", d₁)
    gmsh.model.mesh.field.setNumber(2, "DistMin", d₂)
    gmsh.model.mesh.field.setNumber(2, "DistMax", 4.0*d₁)
    gmsh.model.mesh.field.add("Min", 3)
    gmsh.model.mesh.field.setNumbers(3, "FieldsList", [2])

    gmsh.model.mesh.field.setAsBackgroundMesh(3)

    gmsh.option.setNumber("Mesh.MeshSizeExtendFromBoundary", 0)
    gmsh.option.setNumber("Mesh.MeshSizeFromPoints", 0)
    gmsh.option.setNumber("Mesh.MeshSizeFromCurvature", 0)

    factory.synchronize()
    gmsh.write(filename*".geo_unrolled")

    gmsh.model.mesh.generate(2)
    
    gmsh.write(filename*".msh")
    gmsh.finalize() 
end 

export mesh_square, mesh_cube, mesh_nlayer_ellipse, mesh_hole_square
