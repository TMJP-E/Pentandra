import networkx as nx
G = nx.Graph()

print("¿Cuántos vértices desea ingresar?")
cantidad_vertices= int(input())

while cantidad_vertices<=0:
    print("Número no válido. Intentelo nuevamente.")
    cantidad_vertices= int(input())

contador_vertices=0
while contador_vertices < cantidad_vertices:
    nombre_vertice= input(f"Ingrese el nombre del vértice {contador_vertices +1}: ").lower().strip()
    if nombre_vertice == "":
        print("El nombre del vértice no puede estar vacío.")
    elif nombre_vertice in G.nodes:
        print(f"El vértice '{nombre_vertice}' ya existe. Intentelo nuevamente.")
    else: 
        G.add_node(nombre_vertice)
        print(f"Vértice: {nombre_vertice} registrado correctamente.")
        contador_vertices+=1

print("Cantidad de aristas que desea ingresar: ")
numero_aristas= int(input())

while cantidad_vertices<=0:
    print("Número no válido. Intentelo nuevamente.")
    cantidad_vertices= int(input())
contador_aristas=0
while contador_aristas < numero_aristas:
    print("Arista: ", contador_aristas + 1)
    u= input ("Ingrese el nombre del vértice:")
    v= input ("Ingrese el nombre del vértice:")
    if u not in G.nodes or v not in G.nodes:
        print("Uno o ambos vértices no existen. Intentelo nuevamente.")
    elif u == v:
        print("No se permiten bucles. Ingrese vértices que sean diferentes.")
    elif G.has_edge(u, v) or G.has_edge(v, u):
        print(f"Ya existe una arista  entre {u} y {v}. Intentelo nuevamente.")
    else:
        G.add_edge(u, v)
        print(f"Arista registrada entre: '{u}' y '{v}'")
        contador_aristas+=1
        
if G.number_of_edges() > 0:
    matriz = nx.incidence_matrix(G).toarray()
    print("matriz de incidencia:")
    print(matriz)