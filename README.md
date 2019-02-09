# AniBot

Elaborado por:
  Daniel    Francis 
  Francisco Márquez 

Se explican detalles de implementación y
modo de uso del AniBot.


Ejecutamos a anibot con

-? anibot.

El usuario DEBE escribir todos los comandos en el siguiente formato:

1. Comillas simples para comenzar y terminar
2. Finalizar la línea con un punto.

Por ejemplo:

-? 'Me gusta Kirby'.

AniBot acepta las siguientes frases:

0. 'Fin'.
  
    Finaliza la ejecucion.

a. 'Me gustan animes de GÉNERO1 GÉNERO2 ... GÉNEROn'.
    
    Mostrará los animé de los géneros suministrados.
    
    Pueden ser varios: 
    'Me gustan animes de Shounen Gore'.
    
    o uno solo:
    'Me gustan animes de Shounen'.

b. 'Muestrame animes de GÉNERO'.

    Mostrará los animé del GÉNERO y luego preguntará si
    se quieren ver por rating, popularidad o combinado.
    Para estas opciones debe responder 
    'Por rating'.
    'Por popularidad'.
    'Combinado'.
    respectivamente.

    Luego preguntará si quiere ordenarlos de manera creciente.
    Para ello, responda 'Si'., de lo contrario, diga 'No'.
    Por defecto, se muestran en orden decreciente

c. 'Quisiera animes de NÚMERO estrellas'.

    Mostrará los animé de NÚMERO estrellas, primero preguntando un género
    específico.

d. 'Dime animes buenos por conocer'.

    Muestra animés con más de 3 estrellas y menos de 6 en popularidad

e. 'Dime animes buenos muy poco conocidos'.

    Muestra animés con más de 3 estrellas y entre 1 y 2 en popularidad

f. 'Dime animes buenos poco conocidos'.

    Muestra animés con más de 3 estrellas y entre 3 y 5 en popularidad

g. 'Dime animes buenos conocidos'.

    Muestra animés con con más de 3 estrellas y entre 6 y 7 en popularidad

h. 'Dime animes buenos muy conocidos'.

    Muestra animés con con más de 3 estrellas y entre 8 y 9 en popularidad

i. 'Dime animes buenos bastante conocidos'.

    Muestra animés con con más de 3 estrellas y entre 10 en popularidad 

j. 'Quiero saber si conoces el anime ANIME'.

    Si lo conoce, se guarda que se consultó una vez y revela el  género,
    rating y popularidad. Si no lo conoce, pide los datos al usuario.
    Los numeros deben escribirse de la forma:

    -? 5.


Se tomó como inspiración el diseño del clásico de Prolog Eliza, un chatbot con características similares a las descritas en el enunciado del presente proyecto. El código de Eliza se encuentra presente en el libro de texto del curso, escrito por Shapiro.

Se decidió utilizar átomos en vez de strings para facillitar el manejo de las funciones y poder dedicar el esfuerzo a los algoritmos y a las diferentes verificaciones y maneras de mostrar la información en pantalla. La única desventaja es que AniBot requiere entonces que se escriban las cosas en pantalla de una manera específica. Aún así, se estima que la decisión fue acertada.

Para contabilizar las consultas y aumentar la popularidad se utilizó una regla cíclica. Se hace evidente lo complicado que es manejar variables en prolog. Es necesario hacer uso de trucos y funcionalidades no-comunes para poder enumerar eventos en el ambiente global de la ejecución.



1. elemento/2.
  a. Unifica con los elementos de la lista vacía:
    \+(elemento(X, [])) => Pasa

  b. Busca el elemento 1, en [0..10]:
    elemento(1, [0,1,2,3,4,5,6,7,8,9,10]) => Pasa

  c. Busca el elemento 1, en [2..5]:
    \+(elemento(1, [2,3,4,5])) => Pasa

2. esGenero/2.
  a. El anime es desconocido ('Sailor Moon Crystal'):
    \+(esGenero('Sailor Moon Crystal', X)) => Pasa

  b. El anime es conocido ('Another'):
    b.1 Unifica con los géneros del anime (X = {'Seinen', 'Gore'}).
      esGenero('Another', X) => Pasa

    b.2 Verifica si el anime es del género 'Hentai':
      \+(esGenero('Another', 'Hentai')) => Pasa

  c. El género es desconocido ('Aventura'):
    \+(esGenero(X, 'Aventura')) => Pasa
    
  d. El género es conocido ('Mecha', X = {'Code Geass', 'Gundam', 'Gundam Wing', 'Mazinger Z', 'Medabots', 'Neon Genesis Evangelion'}):
    esGenero(X, 'Mecha') => Pasa

3. agregarAnime/1.
  a. Agrega un anime conocido ('Another'):
    \+(agregarAnime('Another')) => Pasa

  b. Agrega un anime desconocido ('Sailor Moon Crystal'):
    agregarAnime('Sailor Moon Crystal'), anime('Sailor Moon Crystal') => Pasa

4. agregarGenero/1.
  a. Agrega un género conocido ('Nekketsu'):
    \+(agregarGenero('Nekketsu')) => Pasa

  b. Agrega un género desconocido ('Fantasía'):
    agregarGenero('Fantasía'), genero('Fantasía') => Pasa

5. agregarGeneroAnime/2.
  a. Agrega un anime conocido ('Another'):
    a.1. El género es desconocido ('Sobrenatural').
      \+(agregarGeneroAnime('Another', 'Sobrenatural')) => Pasa

    a.2. El género es conocido:
      a.2.1. El anime es de este genero ('Gore'):
        \+(agregarGeneroAnime('Another', 'Gore')) => Pasa
      a.2.2. El anime no es de este genero ('Mecha'):
        agregarGeneroAnime('Another', 'Mecha'), generoAnime('Another', ['Mecha', 'Seinen', 'Gore']) => Pasa

  b. Agrega un anime desconocido ('Sailor Moon Crystal'):
    \+(agregarGeneroAnime('Sailor Moon Crystal', X)) => Pasa

6. agregarRating/2.
  a. El anime es desconocido ('Sailor Moon Crystal'):
    \+(agregarRating('Sailor Moon Crystal', X)) => Pasa

  b. El anime es conocido ('Another'):
    b.1. Estrellas no está en [1..5]:
      b.1.1. Estrellas < 1 (0).
        \+(agregarRating('Another', 0)) => Pasa

      b.1.2. Estrellas > 5 (6).
        \+(agregarRating('Another', 6)) => Pasa

    b.2. Estrellas está en [1..5] (3):
      b.2.1. Existe rating(Anime, _) en la base de conocimiento:
        \+(agregarRating('Another', 3)) => Pasa

      b.2.2. No existe rating(Anime, _) en la base de conocimiento:
        agregarAnime('Sailor Moon Crystal'), agregarRating('Sailor Moon Crystal', 3) => Pasa

7. agregarPopularidad/2.
  a. El anime es desconocido ('Sailor Moon Crystal'):
    \+(agregarPopularidad('Sailor Moon Crystal', X)) => Pasa

  b. El anime es conocido ('Another'):
    b.1. Popularidad no está en [1..10]:
      b.1.1. Estrellas < 1 (0).
        \+(agregarPopularidad('Another', 0)) => Pasa

      b.1.2. Estrellas > 10 (11).
        \+(agregarPopularidad('Another', 11)) => Pasa

    b.2. Estrellas está en [1..10] (3):
      b.2.1. Existe rating(Anime, _) en la base de conocimiento:
        \+(agregarPopularidad('Another', 3)) => Pasa

      b.2.2. No existe rating(Anime, _) en la base de conocimiento:
        agregarAnime('Sailor Moon Crystal'), agregarPopularidad('Sailor Moon Crystal', 3) => Pasa

8. porRating/2.
  a. El género es desconocido, luego devuelve la lista vacía:
    porRating('Fantasía', []) => Pasa

  b. El género es conocido ('Mecha'):
    porRating('Mecha', ['Neon Genesis Evangelion', 'Code Geass', 'Gundam', 'Gundam Wing', 'Medabots', 'Mazinger Z']) => Pasa

9. porPopularidad/2.
  a. El género es desconocido, luego devuelve la lista vacía:
    porPopularidad('Fantasía', []) => Pasa

  b. El género es conocido ('Mecha'):
    porPopularidad('Mecha', ['Neon Genesis Evangelion', 'Code Geass', 'Gundam Wing', 'Gundam', 'Mazinger Z', 'Medabots']) => Pasa

10. combinada/2.
  a. El género es desconocido, luego devuelve la lista vacía:
    combinada('Fantasía', []) => Pasa

  b. El género es conocido ('Mecha'):
    combinada('Mecha', ['Neon Genesis Evangelion', 'Code Geass', 'Gundam Wing', 'Gundam', 'Medabots', 'Mazinger Z']) => Pasa

11. ratingGenero/2.
  a. Todos los anime 'Seinen' de 1 estrellas:
    ratingGenero('Seinen', 1, []) => Pasa
  
  b. Todos los anime 'Seinen' de 2 estrellas:
    ratingGenero('Seinen', 2, ['Saikano']) => Pasa

  c. Todos los anime 'Seinen' de 3 estrellas:
    ratingGenero('Seinen', 3, ['Another', 'Elfen Lied', 'Golden Boy', 'Strawberry Panic']) => Pasa
  
  d. Todos los anime 'Seinen' de 4 estrellas:
    ratingGenero('Seinen', 4, []) => Pasa

  e. Todos los anime 'Seinen' de 5 estrellas:
    ratingGenero('Seinen', 5, ['Gantz', 'Hellsing']) => Pasa

12. buenosPorConocer/2.
  a. Todos los anime con más de 3 estrellas y menos de 6 de popularidad:
    buenosPorConocer(['Anyone You Can Do'-4-4, 'Bible Black'-4-4, 'Cafe Junkies'-4-4, 'Gantz'-4-5, 'Mirai Nikki'-4-5, 'Mizugi Kanojo'-4-4, 'Sensitive Pornograph'-4-4, 'The Prince Of Tennis'-5-4, 'Toukyou Requiem'-4-4]) => Pasa

  b. No puede estar un anime popular en la lista:
    buenosPorConocer(X), \+(elemento('Bleach', X)) => Pasa

  c. No puede estar un anime malo en la lista:
    buenosPorConocer(X), \+(elemento('Saikano', X)) => Pasa

13. agregarConPopularidad/4.
  a. Anime conocido ('Another'):
    \+(agregarConPopularidad('Another', G, E, P)) => Pasa

  b. Anime desconocido ('Sailor Moon Crystal'):
    agregarConPopularidad('Sailor Moon Crystal', 'Mahou Shoujo', 3, 5), anime('Sailor Moon Crystal'), genero('Mahou Shoujo'), rating('Sailor Moon Crystal', 3), popularidad('Sailor Moon Crystal', 5), generoAnime('Sailor Moon Crystal', ['Mahou Shoujo']) => No Pasa

14. agregarSinPopularidad/3.
  a. Anime conocido ('Another'):
    \+(agregarSinPopularidad('Another', G, E)) => Pasa

  b. Anime desconocido ('Sailor Moon Crystal'):
    agregarSinPopularidad('Sailor Moon Crystal', 'Mahou Shoujo', 3), anime('Sailor Moon Crystal'), genero('Mahou Shoujo'), rating('Sailor Moon Shoujo', 3), popularidad('Sailor Moon Shoujo', 1), generoAnime('Sailor Moon Shoujo', ['Mahou Shoujo']) => Pasa

15. subirPopularidad/1.
  a. Anime conocido:
    a.1. Con popularidad menor a 10 ('Another'):
      subirPopularidad('Another'), popularidad('Another', 9) => Pasa

    a.2 Con popularidad mayor a 9 ('Dragon Ball Z'):
      \+(subirPopularidad('Dragon Ball Z')) => Pasa

  b. Anime desconocido ('Sailor Moon Crystal'):
    \+(subirPopularidad('Sailor Moon Crystal')) => Pasa