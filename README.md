# Pentandra <img src="logo.jpg" alt="" width="24">

Pentandra es una aplicación de escritorio que permite crear y analizar grafos de manera dinámica, obteniendo información importante, como sus matrices y el árbol de expansión mínima.

## Propósito

Pentandra permite crear grafos en pantalla con vértices y aristas, indicar nombres y ponderaciones, y, por último, realizar tres operaciones con el grafo creado: calcular la matriz de incidencia, adyacencia y el árbol de expansión mínima.

## Requerimientos

### Funcionales

- [X] El usuario puede crear un vértice en pantalla haciendo doble click en el panel del grafo.

- [X] El usuario puede seleccionar cualquier vértice o arista haciendo click en él.

- [X] El usuario puede unir dos vértices, seleccionando uno de ellos y haciendo click en el otro, generando una arista.

- [X] El usuario, al seleccionar un vértice, puede ingresar un nombre para el vértice, mediante un recuadro de entrada.

- [X] El usuario, al seleccionar una arista, puede ingresar una ponderación de la arista, mediante un recuadro de entrada.

- [X] El usuario, al seleccionar un vértice o arista, puede eliminarlo.

- [X] El usuario puede calcular la matriz de adyacencia del grafo creado.

- [X] El usuario puede calcular la matriz de incidencia del grafo creado.

- [X] El usuario puede calcular el árbol de expansión mínima y el peso mínimo del grafo creado.

### No Funcionales

- [X] Pentandra debe desplegar todos los elementos de un grafo simple no dirigido, estos elementos son: vértices, aristas, nombres de vértices y ponderaciones de aristas.

- [X] Pentandra debe mostrar el grafo en un panel dedicado.

- [X] Pentandra debe manejar las interacciones con el grafo mediante el panel dedicado y recuadros de entrada.

- [X] Pentandra, al calcular el árbol de expansión mínima, debe mostrar cada iteración realizada.

### Sistema

Pentandra debe implementar el algoritmo de Prim para calcular el árbol de expansión mínima.

Pentandra debe utilizar [Python](https://docs.python.org/3/tutorial/index.html) como tecnología para la lógica de negocio.

Pentandra debe utilizar la libreria [NetworkX](https://networkx.org/documentation/stable/tutorial.html) para el manejo de grafos.

Pentandra debe utilizar [Qt](https://doc.qt.io/qtforpython-6/) como tecnología para la interfaz visual.

## Contribuciones

Las siguientes recomendaciones para contribuir garantizan consistencia, legibilidad y fácil entendimiento del proyecto para todos los contribuidores.

### Nombres

Para nombrar variables, existen cinco convenciones a utilizar

| Tipo | Casos de Uso | Ejemplo |
| :-- | :-- | :-- |
| snake_case | Nombrar variables sencillas. | `cantidad_vertices = 5` |
| SCREAMING_SNAKE_CASE | Nombrar constantes. | `MAX_ARISTAS = 100` |
| camelCase | Nombrar funciones, estructuras u objetos. | `aristasDirigidas = invertirAristas(grafoDirigido.edges())` |
| PascalCase | Nombrar clases | `class GrafoSimplificado(nx.Graph)` |
| kebab-case | Nombrar archivos que no sean únicamente clases. | `logo-cuadrado.jpg` |

### Documentacion

Cada clase, método y función debe incluir un _Docstring_ que describa los siguientes elementos:

- Objetivo Principal: Utiliza un verbo para describir que es lo que hace.
- *Detalles: Si es necesario explicar algún detalle de uso adicional.
- *Parámetros: Todos los parámetros que espera una clase (en su constructor), método o función.
- *Retorno: En caso de que regrese algún dato, que información se obtiene.
- *Excepciones: Todos los casos donde pueda arrojar una excepción.

Los elementos marcados con `*` no siempre se encuentran en una clase, método o función.

Las funciones y métodos deben anotar sus tipos, si bien, Python no requiere ni comprueba estos, con ayuda de herramientas como Pylance y sus integraciones, es fácil conocer implícitamente qué tipo espera y, anotar su tipo correspondiente, para que sea más fácil el uso y mantenimiento de cada función.

Algunos de los tipos básicos son:

- `bool`
- `bytearray`
- `bytes`
- `dict`
- `float`
- `frozenset`
- `int`
- `list`
- `set`
- `str`
- `tuple`

#### Ejemplo (documentación)

```python
def conversionInt(cadena: str) -> int:
    """
    Convierte una cadena en un entero.

    La cadena no puede ser un número decimal.

    Regresa el número entero que representa la cadena.

    Arroja `TypeError` si el argumento `cadena` no es un `str`.
    """

    #TODO: Implementar lógica de conversión.
    pass
```

### Estructura

Para garantizar modularización y separación de intereses, la capa de presentación está separada de la lógica de negocio.

Cada _commit_ debe ser realizado conforme a la estructura presentada en [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), con las descripciones de cada commit gracias a [Angular](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines)

#### Formato de commits

Cada commit debe ser escrito con la siguiente estructura:

```none
<tipo>(<area>*): <concepto>

<descripcion>*

<footer>*
```

Los elementos marcados con `*` son opcionales, el concepto debe describir brevemente cuales fueron los cambios principales y siempre inicia con un verbo, en caso de contar con varios cambios, realizar una descripción dedicada.

Los tipos de commits admitidos son los siguientes:

- **build**: Cambios en dependencias o el entorno.
- **docs**: Cambios en la documentación.
- **feat**: Implementación o cambios de un requerimiento.
- **fix**: Corrección de errores.
- **refactor**: Cambios en la estructura y contenido del código existente.
- **style**: Cambios únicamente visuales (como nombres de variables, organización de módulos, etc).
- **test**: Implementación y cambios en el desarrollo de pruebas.

##### Ejemplo (commit)

`feat(visual): Implementación de estilos visuales mediante el formato .qss`

## Uso

### Instalación

Para trabajar en el proyecto, [Python](https://www.python.org/downloads/) debe estar instalado en el sistema, los siguientes comandos crean y activan un entorno virtual en el que se instalarán las dependencias necesarias.

```sh
# Crear el entorno virtual
python -m venv .venv

# Activar el entorno virtual
#Windows CMD
.venv\Scripts\activate.bat
#Windows PowerShell
venv\Scripts\Activate.ps1
#Linux y macOS
source myvenv/bin/activate

# Instalar dependencias
pip install -r requirements.txt
```

### Ejecución

El archivo `main.py` ejecuta la aplicación, para ello se ocupa el siguiente comando.

```sh
python main.py
```
