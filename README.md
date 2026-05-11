# Pentandra <img src="logo.jpg" alt="" width="24">

Pentandra es una aplicacion de escritorio que permite crear y analizar grafos de manera dinamica, obteniendo informacion importante, como sus matrices y el arbol de expansion minima.

## Proposito

Pentandra permite crear grafos en pantalla con vertices y aristas, indicar nombres y ponderaciones, y, por ultimo, realizar tres operaciones con el grafo creado, calcular la matriz de incidencia, adjacencia y el arbol de expansion minima.

## Requerimientos

### Funcionales

- [ ] El usuario puede crear un vertice en pantalla haciendo doble click en el panel del grafo.

- [ ] El usuario puede seleccionar cualquier vertice o arista haciendo click en el.

- [ ] El usuario puede unir dos vertices, seleccionando uno de ellos y haciendo click en el otro, generando una arista.

- [ ] El usuario, al seleccionar un vertice, puede ingresar un nombre para el vertice, mediante un recuadro de entrada.

- [ ] El usuario, al seleccionar una arista, puede ingresar una ponderacion de la arista, mediante un recuadro de entrada.

- [ ] El usuario puede calcular la matriz de adjacencia del grafo creado.

- [ ] El usuario puede calcular la matriz de incidencia del grafo creado.

- [ ] El usuario puede calcular el arbol de expansion minima y el peso minimo del grafo creado.

- [ ] El usuario, al calcular el arbol de expansion minima, puede visualizar cada iteracion realizada por el algoritmo de Prim.

### No Funcionales

- [ ] Pentandra debe desplegar todos los elementos de un grafo simple no dirigido, estos elementos son vertices, aristas, nombres de vertices y ponderaciones de aristas.

- [ ] Pentandra debe mostrar el grafo en un panel dedicado.

- [ ] Pentandra debe manejar las interacciones con el grafo mediante el panel dedicado y recuadros de entrada.

### Sistema

Pentandra debe utilizar [Python](https://www.python.org/) como tecnologia para la logica de negocio.

Pentandra debe utilizar la libreria [NetworkX](https://networkx.org/en/) para el manejo de grafos.

Pentandra debe utilizar [Qt](https://www.qt.io/) como tecnologia para la interfaz visual.

## Contribuciones

Las siguientes recomendaciones para contribuir garantizan consistencia, legibilidad y facil entendimiento del proyecto para todos los contribuidores.

### Nombres

Para nombrar variables, existen cinco convenciones a utilizar.

| Tipo | Casos de Uso | Ejemplo |
| :-- | :-- | :-- |
| snake_case | Nombrar variables sencillas. | `cantidad_vertices = 5` |
| SCREAMING_SNAKE_CASE | Nombrar constantes. | `MAX_ARISTAS = 100` |
| camelCase | Nombrar funciones, estructuras u objetos. | `aristasDirigidas = invertirAristas(grafoDirigido.edges())` |
| PascalCase | Nombrar clases | `class GrafoSimplificado(nx.Graph)` |
| kebab-case | Nombrar archivos que no sean unicamente clases. | `logo-cuadrado.jpg` |

### Documentacion

Cada clase, metodo y funcion debe incluir un _Docstring_ que describa los siguientes elementos:

- Objetivo Principal: Utiliza un verbo para describir que es lo que hace.
- *Detalles: Si es necesario explicar algun detalle de uso adicional.
- *Parametros: Todos los parametros que espera una clase (en su constructor), metodo o funcion.
- *Retorno: En caso de que regrese algun dato, que informacion se obtiene.
- *Excepciones: Todos los casos donde pueda arrojar una excepcion.

Los elementos marcados con `*` no siempre se encuentran en una clase, metodo o funcion.

Las funciones y metodos deben anotar sus tipos, si bien, Python no requiere ni comprueba estos, con ayuda de herramientas como Pylance y sus integraciones, es facil conocer implicitamente que tipo espera y, anotar su tipo correspondiente, para que sea mas facil el uso y mantenimiento de cada funcion.

Algunos de los tipos basicos son:

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

#### Ejemplo (documentacion)

```python
def conversionInt(cadena: str) -> int:
    """
    Convierte una cadena en un entero.

    La cadena no puede ser un numero decimal.

    Regresa el numero entero que representa la cadena.

    Arroja `TypeError` si el argumento `cadena` no es un `str`.
    """

    #TODO: Implementar logica de conversion.
    pass
```

### Estructura

Para garantizar modularizacion y separacion de intereses, la capa de presentacion esta separada de la logica de negocio.

Cada _commit_ debe ser realizado conforme a la estructura presentada en [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/), con las descripciones de cada commit gracias a [Angular](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines)

#### Formato de commits

Cada commit debe ser escrito con la siguiente estructura:

```none
<tipo>(<area>*): <concepto>

<descripcion>*

<footer>*
```

Los elementos marcados con `*` son opcionales, el concepto debe describir brevemente cuales fueron los cambios principales, en caso de contar con varios cambios, realizar una descripcion dedicada.

Los tipos de commits admitidos son los siguientes:

- **build**: Cambios en dependencias o el entorno.
- **docs**: Cambios en la documentacion.
- **feat**: Implementacion o cambios de un requerimiento.
- **fix**: Correccion de errores.
- **refactor**: Cambios en la estructura y contenido del codigo existente.
- **style**: Cambios unicamente visuales (como nombres de variables, organizacion de modulos, etc).
- **test**: Implementacion y cambios en el desarrollo de pruebas.

##### Ejemplo (commit)

`feat(visual): Implementacion de estilos visuales mediante el formato .qss`

## Uso

### Instalacion

Para trabajar en el proyecto, [Python](https://www.python.org/downloads/) debe estar instalado en el sistema, los siguientes comandos crean y activan un entorno virtual en el que se instalaran las dependencias necesarias.

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

### Ejecucion

El archivo `main.py` ejecuta la aplicacion, para ello se ocupa el siguiente comando.

```sh
python main.py
```
