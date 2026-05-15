import networkx as nx 
G = nx.Graph() #Creación del objeto Grafo

#Ingreso de la cantidad de vértices
print("¿Cuántos vértices desea ingresar?")
cantidad_vertices = int(input())

#Validación: Asegura que exista por lo menos un vértice
while cantidad_vertices <= 0:
    print("Número no válido. Intentelo nuevamente.")
    cantidad_vertices = int(input())

#Ingreso del nombre de los vértices
contador_vertices = 0
while contador_vertices < cantidad_vertices:
    nombre_vertice = input(f"Ingrese el nombre del vértice {contador_vertices +1}: ").lower().strip()#Minúsculas y sin espacios
    if nombre_vertice == "": #Asegura que el vértice tenga un nombre
        print("El nombre del vértice no puede estar vacío.")
    elif nombre_vertice in G.nodes: #Evita duplicados
        print(f"El vértice '{nombre_vertice}' ya existe. Intentelo nuevamente.") 
    else: 
        G.add_node(nombre_vertice) #Agrega un nuevo vértice al grafo
        contador_vertices+=1

#Ingreso de la cantidad de aristas
print("Cantidad de aristas que desea ingresar: ")
cantidad_aristas= int(input())

#Validación Cantidad de aristas
#Cantidad máx. de aristas que pueden existir en el grafo
max_aristas= ((cantidad_vertices * (cantidad_vertices-1))/2) 

while cantidad_aristas <= 0 or cantidad_aristas > max_aristas:
    print("Número no válido. Intentelo nuevamente.")
    cantidad_aristas= int(input())

#Creación de las aristas mediante los nombres de los vértices
contador_aristas = 0

while contador_aristas < cantidad_aristas:
    print("Arista: ", contador_aristas + 1)
    u= input ("Ingrese el nombre del vértice:").lower().strip() #Minúsculas y sin espacios
    v= input ("Ingrese el nombre del vértice:").lower().strip() #Minúsculas y sin espacios
    
    #Validación para la creación de las aristas
    if u not in G.nodes or v not in G.nodes: #Asegura que los vertices existan
        print("Uno o ambos vértices no existen. Intentelo nuevamente.")
    elif u == v: #Evita que se generen bucles
        print("No se permiten bucles. Ingrese vértices que sean diferentes.")
    elif G.has_edge(u, v) or G.has_edge(v, u): #Evita que se creen dos aristas iguales
        print(f"Ya existe una arista  entre {u} y {v}. Intentelo nuevamente.")
    else:
        G.add_edge(u, v) #Agrega una arista nueva al grafo
        contador_aristas+=1

#Impresión de la matriz de incidencia 

if G.number_of_edges() > 0: #Valida que existan aristas en el grafo
#Convierte la matriz de incidencia a una estándar para desplegarla
    matriz = nx.incidence_matrix(G).toarray()
    print("Matriz de incidencia:")
    print(matriz)
