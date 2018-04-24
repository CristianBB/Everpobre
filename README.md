# Everpobre

Aplicación iOS para la gestión de notas organizadas en libretas.

Práctica del VI BootCamp Development Mobile - KeepCoding.

![Tratamiento de Imagenes](./shortDemo.gif)

![Seccion Personalizada](./customSection.gif)

**Demo de funcionamiento** ![Everpobre](./demo.mov)


## Dependencias Carthage
- WSTagsField
- SkyFloatingLabelTextField

**Ambos componentes han sido incluidos en el repositorio para evitar problemas en la revisión de la práctica**

## Idiomas admitidos
- Inglés (Idioma base)
- Español

## Descripción de Funcionamiento
- **Alta de Notas rápidas**, asociadas automáticamente al notebook por defecto. Para dar de alta una nota rápida pulsar el icono "Agregar nota" en la barra de navegación.
- **Alta de Libretas**. Para dar de alta una libreta pulsar el icono "Libro"
- **Alta de Nota asociada a una libreta**. Cada Libreta dispone de un icono "Agregar nota" que, al pulsarlo, añadirá una nota directamente a la libreta.
- **Modo Edición**. Para activar el modo de Edición pulsar el icono "Editar" de la barra de navegación. Al activar el modo edición aparecerá un icono en la parte izquierda de cada fila de la tabla que permite acceder a las opciones de edición específicas de una Libreta o nota
    - **Editar Libreta**: Al pulsar en el icono "Editar" asociado a una libreta se liberan las siguientes acciones
        - **Marcar Libreta por defecto** (siempre que la libreta no lo sea). Permite marcar la libreta seleccionada por defecto de manera que las notas rápidas serán dadas de alta en ella. Únicamente puede existir una libreta por defecto.
        - **Editar nombre de la libreta**
        - **Eliminar libreta**. Elimina la libreta seleccionada. Si la libreta tiene notas asociadas se preguntará al usuario si desea eliminar todas las libretas asociadas o asociarlas a una libreta diferente. **La libreta por defecto no puede ser eliminada**
    - **Editar Nota**: Al pulsar el icono "Editar" asociado a una Nota se libera la acción para eliminar la Nota
- **Agregar imágenes/localización a una nota**. Para agregar una imagen o mapa a una nota es necesario realizar una pulsación larga en el área de texto desginado al texto de la nota, tras lo cual aparecerá un menú que permitirá agregar una imagen desde la galería, desde la cámara de fotos o acceder a la búsqueda de lugares para agregar un mapa. La imagen en cuestión será añadida en la posición donde se realizó la pulsación larga.
- **Editar imagen**. Para entrar en el modo de edición de imágen es necesario realizar dos pulsaciones sobre la imagen deseada. Las opciones de edicion disponibles son:
    - **Rotar imagen a la izquierda**. Para lo cual será necesario realizar un deslizamiento hacia la izquierda dentro de la imagen.
    - **Rotar imagen a la derecha**. Realizando un deslizamiento hacia la derecha dentro de la imagen.
    - **Escalar imagen**. Mediante la realización de un pinzamiento dentro de la imagen. 
    - **Borrar imagen**. Realizando un deslizamiento hacia abajo dentro de la imagen.


## Autor
**Cristian Blázquez Bustos**