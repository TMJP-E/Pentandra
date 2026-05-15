import time
import colorsys as colors
import networkx as nx
from PySide6.QtCore import (
    QAbstractListModel,
    QCoreApplication,
    Qt,
    Slot,
    QByteArray,
    QModelIndex,
)


class GraphModel(QAbstractListModel):
    """
    Modelo de datos de un Grafo

    GraphModel extiende un modelo de datos en Qt, que otorga una estructura de
    información, para representar un grafo.
    Expone el objeto Graph, proveniente de NetworkX, ofreciendo interfaces para
    interactuar con los nodos, aristas, y datos contenidos en cada uno.

    El modelo posee un ID para cada elemento del grafo y, distingue el tipo de
    elemento (si es un nodo o arista), los datos de nodos y aristas son distintos.

    Los nodos tienen una posicion, opcionalmente un nombre, y un color que es utilizado
    para cada iteración del árbol mínimo.

    Las aristas tienen las posiciones de inicio y fin, opcionalmente, un peso que es
    utilizado para cada iteración del árbol mínimo.
    """

    IdRole = Qt.UserRole + 1
    TypeRole = Qt.UserRole + 2
    NameRole = Qt.UserRole + 3
    ColorRole = Qt.UserRole + 4
    WeightRole = Qt.UserRole + 5
    XPointRole = Qt.UserRole + 6
    YPointRole = Qt.UserRole + 7
    StartXRole = Qt.UserRole + 8
    StartYRole = Qt.UserRole + 9
    EndXRole = Qt.UserRole + 10
    EndYRole = Qt.UserRole + 11

    def __init__(self, parent=None):
        super().__init__(parent)
        self._graph = nx.Graph()
        self._items = []
        self._highlight_color = "#FF70F1"

    def roleNames(self):
        return {
            self.IdRole: QByteArray(b"elementId"),
            self.TypeRole: QByteArray(b"elementType"),
            self.NameRole: QByteArray(b"elementName"),
            self.ColorRole: QByteArray(b"elementColor"),
            self.WeightRole: QByteArray(b"modelWeight"),
            self.XPointRole: QByteArray(b"modelXPoint"),
            self.YPointRole: QByteArray(b"modelYPoint"),
            self.StartXRole: QByteArray(b"modelStartX"),
            self.StartYRole: QByteArray(b"modelStartY"),
            self.EndXRole: QByteArray(b"modelEndX"),
            self.EndYRole: QByteArray(b"modelEndY"),
        }

    def rowCount(self, parent=QModelIndex()):
        return len(self._items)

    def data(self, index, role=Qt.DisplayRole):
        if not (index.isValid() and (0 <= index.row() < len(self._items))):
            return None

        item = self._items[index.row()]

        if role == self.TypeRole:
            return item.get("type")
        if role == self.NameRole:
            return item.get("name")
        if role == self.ColorRole:
            return item.get("color", "")

        if item["type"] == "node":
            if role == self.IdRole:
                return str(item["id"])
            if role == self.XPointRole:
                return item.get("x")
            if role == self.YPointRole:
                return item.get("y")

        elif item["type"] == "edge":
            if role == self.IdRole:
                return f"{item['u']}-{item['v']}"
            if role == self.WeightRole:
                return item.get("weight", "")

            u_data = self._graph.nodes[item["u"]]
            v_data = self._graph.nodes[item["v"]]
            if role == self.StartXRole:
                return u_data.get("x")
            if role == self.StartYRole:
                return u_data.get("y")
            if role == self.EndXRole:
                return v_data.get("x")
            if role == self.EndYRole:
                return v_data.get("y")

        return None

    def _sync_items(self):
        """
        Sincroniza el estado interno del grafo con el modelo.
        """
        self.beginResetModel()
        self._items = []
        for node, data in self._graph.nodes(data=True):
            self._items.append({"type": "node", "id": node, **data})
        for u, v, data in self._graph.edges(data=True):
            self._items.append({"type": "edge", "u": u, "v": v, **data})
        self.endResetModel()

    @Slot(int, float, float)
    def addNode(self, node_id: int, x: float, y: float):
        self._graph.add_node(node_id, x=x, y=y)
        self._sync_items()

    @Slot(int, str)
    def setNodeName(self, node_id: int, name: str):
        if self._graph.has_node(node_id):
            self._graph.nodes[node_id]["name"] = name
            self._sync_items()

    @Slot(int, float, float)
    def updateNodePosition(self, node_id: int, x: float, y: float):
        """
        Actualiza la posición del nodo y, las aristas conectadas utilizando el metodo
        `_notifyConnectedEdges()`, su uso principal es actualizar la posicion en
        pantalla del nodo y mantener las aristas sincronizadas.
        """
        if node_id in self._graph:
            self._graph.nodes[node_id]["x"] = x
            self._graph.nodes[node_id]["y"] = y

        for i, item in enumerate(self._items):
            if item.get("type") == "node" and item.get("id") == node_id:
                item["x"] = x
                item["y"] = y
                id = self.index(i, 0)
                self.dataChanged.emit(id, id, [self.XPointRole, self.YPointRole])
                self._notifyConnectedEdges(node_id)
                break

    def _notifyConnectedEdges(self, node_id: int):
        for i, item in enumerate(self._items):
            if item.get("type") == "edge" and (
                item.get("u") == node_id or item.get("v") == node_id
            ):
                id = self.index(i, 0)
                self.dataChanged.emit(
                    id,
                    id,
                    [self.StartXRole, self.StartYRole, self.EndXRole, self.EndYRole],
                )

    @Slot(int)
    def removeNode(self, node_id: int):
        if self._graph.has_node(node_id):
            self._graph.remove_node(node_id)
            self._sync_items()

    @Slot(int, int)
    def addEdge(self, u: int, v: int):
        if self._graph.has_node(u) and self._graph.has_node(v):
            self._graph.add_edge(u, v)
            self._sync_items()

    @Slot(int, int, float)
    def setEdgeWeight(self, u: int, v: int, weight: float):
        if self._graph.has_edge(u, v):
            self._graph[u][v]["weight"] = weight
            self._sync_items()

    @Slot(int, int)
    def removeEdge(self, u: int, v: int):
        if self._graph.has_edge(u, v):
            self._graph.remove_edge(u, v)
            self._sync_items()

    @Slot(result=str)
    def getAdjacencyMatrix(self) -> str:
        if self._graph.number_of_nodes() == 0:
            return "El grafo debe tener al menos un nodo."

        matrix = nx.adjacency_matrix(self._graph, weight=None).toarray()
        matrix_string = ""

        for row in matrix:
            matrix_string += f"{str(row)}\n"

        return matrix_string.replace(".", "")

    @Slot(result=str)
    def getIncidenceMatrix(self) -> str:
        if self._graph.number_of_nodes() < 2:
            return "El grafo debe tener al menos dos nodos y una arista."

        if nx.is_empty(self._graph):
            return "El grafo no contiene aristas."

        matrix = nx.incidence_matrix(self._graph).toarray()
        matrix_string = ""

        for row in matrix:
            matrix_string += f"{str(row)}\n"

        return matrix_string.replace(".", "")

    def _update_node_color(self, element_type: str, element_id: int, color_value: str):
        """
        Actualiza, de manera dinámica, el color del nodo, utilizado para demostrar
        las iteraciones del algoritmo para obtener el árbol mínimo.
        """

        self._graph.nodes[element_id]["color"] = color_value
        for i, item in enumerate(self._items):
            if (
                element_type == "node"
                and item.get("type") == "node"
                and item.get("id") == element_id
            ):
                item["color"] = color_value
                id = self.index(i, 0)
                self.dataChanged.emit(id, id, [self.ColorRole])
                break

    def _update_edge_color(self, element_type: str, u: int, v: int, color_value: str):
        """
        Actualiza, de manera dinámica, el color del arista, utilizado para demostrar
        las iteraciones del algoritmo para obtener el árbol mínimo.
        """

        self._graph[u][v]["color"] = color_value
        for i, item in enumerate(self._items):
            if element_type == "edge" and item.get("type") == "edge":
                target_id = f"{u}-{v}"
                current_id = f"{item.get('u')}-{item.get('v')}"
                reverse_id = f"{item.get('v')}-{item.get('u')}"
                if target_id == current_id or target_id == reverse_id:
                    item["color"] = color_value
                    id = self.index(i, 0)
                    self.dataChanged.emit(id, id, [self.ColorRole])
                    break

    def _hexToRGB(self, hex: str) -> tuple[float, float, float]:
        color = hex[1:]
        return tuple(int(color[i : i + 2], 16) for i in (0, 2, 4))

    def _rgbToHEX(self, rgb: tuple[int, int, int]) -> str:
        return "#%02x%02x%02x" % rgb

    def _darkenColor(self, hex: str, amount=0.8) -> str:
        rgb = self._hexToRGB(hex)
        hls = colors.rgb_to_hls(rgb[0], rgb[1], rgb[2])
        r, g, b = colors.hls_to_rgb(hls[0], 1 - amount * (1 - hls[1]), hls[2])
        return self._rgbToHEX((int(r), int(g), int(b)))

    @Slot(result=str)
    def getMST(self) -> str:
        if self._graph.number_of_nodes() < 2:
            return "El grafo debe tener al menos dos nodos y una arista."

        if (
            len(nx.get_edge_attributes(self._graph, "weight"))
            != self._graph.number_of_edges()
        ):
            return "Todos los nodos deben tener un peso."

        if nx.is_negatively_weighted(self._graph):
            return "Los pesos no pueden ser negativos."

        if not nx.is_connected(self._graph):
            return "El grafo debe ser conexo."

        self.clearColors()

        # Realiza la iteracion base.
        start_node = list(self._graph.nodes)[0]
        visited_nodes = {start_node}
        mst_edges = []
        total_weight = 0.0
        self._update_node_color("node", start_node, self._highlight_color)
        QCoreApplication.processEvents()
        time.sleep(0.5)

        # Ejecuta el algoritmo utilizando el nodo base.
        num_nodes = self._graph.number_of_nodes()
        while len(visited_nodes) < num_nodes:
            min_weight = float("inf")
            best_edge = None
            next_node = None

            # Para cada nodo que ya hemos analizado, obtiene la arista mas baja.
            # No considera los nodos ni aristas que ya hemos comprobado, evita ciclos.
            for u in visited_nodes:
                for v, edge_data in self._graph[u].items():
                    if v not in visited_nodes:
                        weight = edge_data.get("weight", 0.0)
                        if weight < min_weight:
                            min_weight = weight
                            best_edge = (u, v)
                            next_node = v

            # Al encontrar la arista minima, la agrega y actualiza el peso.
            # Si no hay una arista minima, el algoritmo ha concluido
            if best_edge:
                u, v = best_edge
                visited_nodes.add(next_node)
                mst_edges.append(best_edge)
                total_weight += min_weight

                node_color = self._highlight_color
                edge_color = self._darkenColor(self._highlight_color)
                self._update_node_color("node", next_node, node_color)
                self._update_edge_color("edge", u, v, edge_color)
                QCoreApplication.processEvents()
                time.sleep(0.5)
            else:
                break

        return f"Peso Total: {total_weight}"

    @Slot()
    def clearColors(self):
        for n in self._graph.nodes:
            self._graph.nodes[n].pop("color", None)
        for u, v in self._graph.edges:
            self._graph[u][v].pop("color", None)
        self._sync_items()

    @Slot(result=bool)
    def isGraphEmpty(self) -> bool:
        return self._graph.number_of_nodes() == 0

    @Slot(result=bool)
    def hasColors(self) -> bool:
        for n in self._graph.nodes:
            if "color" in self._graph.nodes[n]:
                return True
        for u, v in self._graph.edges:
            if "color" in self._graph[u][v]:
                return True
        return False

    @Slot()
    def clearGraph(self):
        self._graph.clear()
        self._sync_items()
