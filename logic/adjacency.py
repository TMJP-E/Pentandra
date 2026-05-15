import networkx as nx
import numpy as np

# Crear grafo
G = nx.Graph()

# ingreso aristas

cantidad_vertices = int(input("¿Cuántos vértices desea ingresar?: "))

contador_vertices = 0

while contador_vertices < cantidad_vertices:

    nombre_vertice = input(f"Ingrese el nombre del vértice {contador_vertices + 1}: ").lower().strip()

    # validar nombre vacío
    if nombre_vertice == "":
        print("El nombre no puede estar vacío.")
    
    # validar nombres repetidos
    elif nombre_vertice in G.nodes:
        print("Ese vértice ya existe.")
    
    else:
        G.add_node(nombre_vertice)

        print(f"Vértice '{nombre_vertice}' agregado.")

        contador_vertices += 1

#ingreso de aristas

numero_aristas = int(input("\n¿Cuántas aristas desea ingresar?: "))

contador_aristas = 0

while contador_aristas < numero_aristas:

    print(f"\nArista {contador_aristas + 1}")

    u = input("Desde: ").lower().strip()
    v = input("Hasta: ").lower().strip()

    # validar vértices
    if u not in G.nodes or v not in G.nodes:
        print("Error: alguno de los vértices no existe.")

    else:
        peso = float(input("Peso de la arista: "))

        # agregar arista ponderada
        G.add_edge(u, v, weight=peso)

        print(f"Arista {u} - {v} con peso {peso} agregada.")
        contador_aristas += 1

# matriz de adyacecia
matriz = nx.to_numpy_array( G, weight='weight', dtype=float)

print("\nOrden de nodos:")
print(list(G.nodes))
print("\nMatriz de adyacencia ponderada:")
print(matriz)
