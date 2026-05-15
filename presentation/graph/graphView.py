import networkx as nx
from PySide6.QtCore import QAbstractListModel, Qt, Slot, QByteArray, QModelIndex


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
        print(self._items)
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
