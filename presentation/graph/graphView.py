import random
import time

import networkx as nx
import scipy as sp
from PySide6.QtCore import (
    QAbstractListModel,
    QCoreApplication,
    Qt,
    Slot,
    QByteArray,
    QModelIndex,
)


class GraphView(QAbstractListModel):
    IdRole = Qt.UserRole + 1
    TypeRole = Qt.UserRole + 2
    NameRole = Qt.UserRole + 3
    XPointRole = Qt.UserRole + 4
    YPointRole = Qt.UserRole + 5
    StartXRole = Qt.UserRole + 6
    StartYRole = Qt.UserRole + 7
    EndXRole = Qt.UserRole + 8
    EndYRole = Qt.UserRole + 9
    WeightRole = Qt.UserRole + 10
    ColorRole = Qt.UserRole + 11

    def __init__(self, parent=None):
        super().__init__(parent)
        self._graph = nx.Graph()
        self._items = []

    def roleNames(self):
        return {
            self.IdRole: QByteArray(b"elementId"),
            self.TypeRole: QByteArray(b"elementType"),
            self.NameRole: QByteArray(b"elementName"),
            self.XPointRole: QByteArray(b"modelXPoint"),
            self.YPointRole: QByteArray(b"modelYPoint"),
            self.WeightRole: QByteArray(b"modelWeight"),
            self.StartXRole: QByteArray(b"modelStartXPoint"),
            self.StartYRole: QByteArray(b"modelStartYPoint"),
            self.EndXRole: QByteArray(b"modelEndXPoint"),
            self.EndYRole: QByteArray(b"modelEndYPoint"),
            self.ColorRole: QByteArray(b"modelColor"),
        }

    def rowCount(self, parent=QModelIndex()):
        return len(self._items)

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid() or not (0 <= index.row() < len(self._items)):
            return None

        item = self._items[index.row()]

        if role == self.TypeRole:
            return item.get("type")
        if role == self.NameRole:
            return item.get("name", "")
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
        self.beginResetModel()
        self._items = []
        for n, data in self._graph.nodes(data=True):
            self._items.append({"type": "node", "id": n, **data})
        for u, v, data in self._graph.edges(data=True):
            self._items.append({"type": "edge", "u": u, "v": v, **data})
        self.endResetModel()

    @Slot(int, float, float)
    def addNode(self, node_id, x, y):
        self._graph.add_node(node_id, x=x, y=y)
        self._sync_items()

    @Slot(int, str)
    def setNodeName(self, node_id, name):
        if self._graph.has_node(node_id):
            self._graph.nodes[node_id]["name"] = name
            self._sync_items()

    @Slot(int, float, float)
    def updateNodePosition(self, node_id, x, y):
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

    def _notifyConnectedEdges(self, node_id):
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
    def removeNode(self, node_id):
        if self._graph.has_node(node_id):
            self._graph.remove_node(node_id)
            self._sync_items()

    @Slot(int, int)
    def addEdge(self, u, v):
        if self._graph.has_node(u) and self._graph.has_node(v):
            self._graph.add_edge(u, v)
            self._sync_items()

    @Slot(int, int, float)
    def setEdgeWeight(self, u, v, weight):
        if self._graph.has_edge(u, v):
            self._graph[u][v]["weight"] = weight
            self._sync_items()

    @Slot(int, int)
    def removeEdge(self, u, v):
        if self._graph.has_edge(u, v):
            self._graph.remove_edge(u, v)
            self._sync_items()

    @Slot(result=str)
    def getAdjacencyMatrix(self):
        if self._graph.number_of_nodes() == 0:
            return "El grafo debe tener al menos un nodo."

        matrix = nx.adjacency_matrix(self._graph, weight=None).toarray()
        matrix_string = ""

        for row in matrix:
            matrix_string += f"{str(row)}\n"

        return matrix_string.replace(".", "")

    @Slot(result=str)
    def getIncidenceMatrix(self):
        if self._graph.number_of_nodes() < 2:
            return "El grafo debe tener al menos dos nodos y una arista."

        if nx.is_empty(self._graph):
            return "El grafo no contiene aristas."

        matrix = nx.incidence_matrix(self._graph).toarray()
        matrix_string = ""

        for row in matrix:
            matrix_string += f"{str(row)}\n"

        return matrix_string.replace(".", "")

    def _update_element_color(self, element_type, element_id, color_value):
        for i, item in enumerate(self._items):
            if (
                element_type == "node"
                and item.get("type") == "node"
                and item.get("id") == element_id
            ):
                item["color"] = color_value
                idx = self.index(i, 0)
                self.dataChanged.emit(idx, idx, [self.ColorRole])
                break
            elif element_type == "edge" and item.get("type") == "edge":
                target_id = f"{element_id[0]}-{element_id[1]}"
                reverse_id = f"{element_id[1]}-{element_id[0]}"
                current_id = f"{item.get('u')}-{item.get('v')}"
                if current_id == target_id or current_id == reverse_id:
                    item["color"] = color_value
                    idx = self.index(i, 0)
                    self.dataChanged.emit(idx, idx, [self.ColorRole])
                    break

    @Slot(result=str)
    def getMST(self):
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

        start_node = list(self._graph.nodes)[0]
        visited_nodes = {start_node}
        mst_edges = []
        total_weight = 0.0

        highlight_color = "#20D75B"

        self._graph.nodes[start_node]["color"] = highlight_color
        self._update_element_color("node", start_node, highlight_color)
        QCoreApplication.processEvents()
        time.sleep(0.5)

        num_nodes = self._graph.number_of_nodes()

        while len(visited_nodes) < num_nodes:
            min_weight = float("inf")
            best_edge = None
            next_node = None

            for u in visited_nodes:
                for v, edge_data in self._graph[u].items():
                    if v not in visited_nodes:
                        weight = edge_data.get("weight", 0.0)
                        if weight < min_weight:
                            min_weight = weight
                            best_edge = (u, v)
                            next_node = v

            if best_edge:
                u, v = best_edge
                visited_nodes.add(next_node)
                mst_edges.append(best_edge)
                total_weight += min_weight

                self._graph.nodes[next_node]["color"] = highlight_color
                self._graph[u][v]["color"] = highlight_color

                self._update_element_color("edge", best_edge, highlight_color)
                self._update_element_color("node", next_node, highlight_color)
                QCoreApplication.processEvents()
                time.sleep(0.5)
            else:
                break

        return f"Peso Total: {total_weight}"

    @Slot()
    def clearColors(self):
        for n in self._graph.nodes:
            if "color" in self._graph.nodes[n]:
                del self._graph.nodes[n]["color"]
        for u, v in self._graph.edges:
            if "color" in self._graph[u][v]:
                del self._graph[u][v]["color"]
        self._sync_items()

    @Slot(result=bool)
    def isGraphEmpty(self):
        return self._graph.number_of_nodes() == 0

    @Slot(result=bool)
    def hasColors(self):
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
