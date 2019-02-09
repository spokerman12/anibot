/* Título: AniBot.pl
 * 
 * Elaborado por:
 * Daniel    Francis 12-10863
 * Francisco Márquez 12-11163
 *
 * Descripción: Base de conocimientos para el chatbot AniBot.
 *
 */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Funciones para el funcionamiento %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% de AniBot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 * anibot/0
 * Funcion principal de la aplicacion
 * Referirse al readme para leer las instrucciones.
 */

anibot :-
    write('AniBot: '), read(Input), anibot(Input), !.

/*
 * anibot/1
 * anibot(Input) :- Lee la entrada de texto y 
 * llama al interpretador
 */

anibot(Input) :-
    Input == 'Fin',write('¡Hasta luego!'),nl,!;
    atomic_list_concat(L, ' ', Input),nl,matchPatron(L),!,anibot;
    respVaga(Input),!, nl, anibot.

/*
 * matchPatron/1
 * matchPatron(Texto) :- Utiliza las reglas de match para
 * conectar patrones y entradas
 * 
 */

matchPatron([]).
matchPatron(X) :-
    (match(X,['Me',gustan,animes,de]), sub(X,['Me',gustan,animes,de],Generos),!,
            respMegustan(Generos));
    (match(X,['Muestrame',animes,de]), sub(X,['Muestrame',animes,de],[L|_Ls]),!,
            respReq1(L));
    (match(X,['Quisiera',animes,de]), sub(X,['Quisiera',animes,de],Estrellas),!,
            nth0(0,Estrellas,Numero),atom_number(Numero,Int),
            respReq2(Int));
    (match(X,['Dime',animes,buenos,por,conocer]),!,
            write('¡Tengo estos que te pueden encantar! Te daré el nombre, la popularidad y las estrellas'),nl,
            buenosPorConocer(Lista),prettyPrint(Lista),nl);
    (match(X,['Dime',animes,buenos,muy,poco,conocidos]),!,
            write('Con que eres curioso. Puede que te gusten estos... Te daré el nombre, la popularidad y las estrellas'),nl,
            muyPocoConocidos(Lista),prettyPrint(Lista),nl);
    (match(X,['Dime',animes,buenos,poco,conocidos]),!,
            write('¡Solo para fanáticos! Te daré el nombre, la popularidad y las estrellas'),nl,
            pocoConocidos(Lista),prettyPrint(Lista),nl);
    (match(X,['Dime',animes,buenos,conocidos]),!,
            write('Probablemente los hayas visto en Animax... Te daré el nombre, la popularidad y las estrellas'),nl,
            conocidos(Lista),prettyPrint(Lista),nl);
    (match(X,['Dime',animes,buenos,muy,conocidos]),!,
            write('Estos han aparecido en Cartoon Network. Te daré el nombre, la popularidad y las estrellas'),nl,
            muyConocidos(Lista),prettyPrint(Lista),nl);
    (match(X,['Dime',animes,buenos,bastante,conocidos]),!,
            write('¡Hasta en Televen los pasaban! Te daré el nombre, la popularidad y las estrellas'),nl,
            bastanteConocidos(Lista),prettyPrint(Lista),nl);
    (match(X,['Quiero',saber,si,conoces,el,anime]), sub(X,['Quiero',saber,si,conoces,el,anime],Anime),!,
            atomic_list_concat(Anime,' ',Limpio),
            write('¿'),write(Limpio),write('?'),nl,
            ((anime(Limpio),
              write('Claro, su clasificación es '),generoAnime(Limpio,Genero),write(Genero),nl,
              write('Tiene rating de '),rating(Limpio,Rating),write(Rating),write(' estrellas'),nl,
              write('y una popularidad de '),popularidad(Limpio,Popularidad),write(Popularidad),nl,
              agregaConsulta(Limpio));
             \+ anime(Limpio), respReq3(Limpio)));
    write('Ehh... tienes gustos peculiares...'),nl,anibot,!.

/*
 * respMegustan/1
 * respMegustan(Lista) :- Muestra una lista de diferentes generos de anime
 */

respMegustan(Lista) :-
    write('Te pueden gustar estos:'),nl,
    variosGeneros(Lista,L),prettyPrint(L),nl.

/*
 * variosGeneros/2
 * variosGeneros(Lista1,Lista2) :- Extrae los generos de Lista1
 * y trae la lista de animes en Lista2
 */

variosGeneros([X|Y],L) :- 
    delGenero(X,L1),genero(X),
    variosGeneros(Y,L2),
    append(L1,L2,L).

variosGeneros([X|[]],L) :- 
    delGenero(X,L),genero(X);
    write('(No conozco animes de '),write(X),write(')'),nl.

/*
 * respReq1/1
 * respReq1(Genero) :- Muestra las opciones para mostrar animes por genero
 * (Correspondiente al primer requerimiento del enunciado)
 */

respReq1(Genero) :-
    write(Genero),
    write('Puede que conozca algunos.'),nl,
    write('¿Te los muestro por rating, por popularidad o combinado?'),nl,
    read(Criterio), 
    (Criterio == 'Por rating'; Criterio == 'Por popularidad'; Criterio == 'Combinado'),
    write('¿Los ordeno de manera creciente?'),nl,
    read(Orden),
    (Orden == 'Si'; Orden == 'No'),
    salidaReq1(Genero,Criterio,Orden),nl.

/*
 * salidaReq1/3
 * salidaReq1(Genero,Criterio,Orden) :- Respuesta de AniBot 
 * a la solicitud del criterio 1.
 */

salidaReq1(Genero,Criterio,Orden) :-
    (Criterio == 'Por rating', (Orden == 'Si'), porRatingInverso(Genero,Lista), prettyPrint(Lista));
    (Criterio == 'Por rating', (Orden == 'No'), porRating(Genero,Lista), prettyPrint(Lista));
    (Criterio == 'Por popularidad', (Orden == 'No'), porPopularidad(Genero,Lista), prettyPrint(Lista));
    (Criterio == 'Por popularidad', (Orden == 'Si'), porPopularidadInverso(Genero,Lista), prettyPrint(Lista));
    (Criterio == 'Combinado', (Orden == 'No'), combinada(Genero,Lista), prettyPrint(Lista));
    (Criterio == 'Combinado', (Orden == 'Si'), combinadaInverso(Genero,Lista), prettyPrint(Lista)).

/*
 * respReq2/1
 * respReq2(Numero) :- Muestra las opciones para mostrar animes de un genero por estrellas
 * (Correspondiente al segundo requerimiento del enunciado)
 */

respReq2(Numero) :-
    between(1,5,Numero),
    write('Creo que conozco un par. ¿De qué genero, específicamente?'),nl,
    read(Genero),
    write('Ok...'),nl,
    ratingGenero(Genero,Numero,Lista),salidaReq2(Lista).

/*
 * salidaReq2/1
 * salidaReq2(Lista) :- Respuesta de AniBot a la solicitud
 * del criterio 2.
 */

salidaReq2(Lista) :- 
    (Lista == [], write('Vaya, no conozco ninguno.'),nl);
    prettyPrint(Lista),nl.

/*
 * respReq3/1
 * respReq3(Anime) :- Muestra las opciones para agregar un anime
 * (Correspondiente al tercer requerimiento del enunciado)
 */

respReq3(Anime) :-
    write('No lo conozco... Del 1 al 10, ¿qué tan popular es? Si no sabes di 0'),nl,
    read(Popularidad),
    write('¿Cuál es el género?'),nl,
    read(Genero),
    write('¿Y, de 1 a 5, cuántas estrellas le das?'),nl,
    read(Estrellas),
    salidaReq3(Anime,Popularidad,Genero,Estrellas).

/*
 * salidaReq3/4
 * salidaReq3(Anime,Popularidad,Genero,Estrellas) :- Muestra la respuesta
 * de AniBot de agregar un nuevo anime.
 */

salidaReq3(Anime,Popularidad,Genero,Estrellas) :-
    ((Popularidad == 0, agregarSinPopularidad(Anime,Genero,Estrellas));
    agregarConPopularidad(Anime,Genero,Estrellas,Popularidad)),
    write('Listo. Lo tendré en mente. ¡Gracias!'),nl.


/*
 * respVaga/1
 * respVaga(Lista) :- Da una respuesta vaga al usuario, si
 * la entrada de texto no es adecuada.
 */

respVaga(Lista) :- write('No entiendo '),write(Lista),nl.
  %% (countRespuesta(0), write('No entiendo '),write(Lista),nl);
  %% (countRespuesta(1), write('¿Qué quieres decir con '),write(Lista),write('?'),nl);
  %% (countRespuesta(2), write('Creo que aún no pasas Algoritmos 3...'),nl).

/*
 * countRespuesta(0) :- Ayuda a rotar las respuestas vagas.
 */

:- dynamic countRespuesta/1.
countRespuesta(0).
%%countRespuesta(X).

/*
 * rotaRespuesta :- Rota las respuestas vagas.
 */

:- dynamic rotaRespuesta/0.
rotaRespuesta :-
  (countRespuesta(0), retract(countRespuesta(0)), asserta(countRepuesta(1)),!);
  (countRespuesta(1), retract(countRespuesta(1)), asserta(countRepuesta(2)),!);
  (countRespuesta(2), retract(countRespuesta(2)), asserta(countRepuesta(0)),!).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Predicados Auxiliares %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 * reverse/3
 * reverse(Lista,Invertida,Acumulador) :- Lg es una lista de géneros de anime.
 * Uso: reverse([1,2,3],Z,[]) resulta en Z = [3,2,1]
 */

reverse([],Z,Z).
reverse([H|T],Z,Acc) :- reverse(T,Z,[H|Acc]).

/*
 * prettyPrint/1
 * prettyPrint(Lista) :- Imprime los elementos de Lista con newlines
 */

prettyPrint([X|[]]) :- write(X).
prettyPrint([X|Y]) :- prettyPrint([X]),nl, prettyPrint(Y).

/*
 * match/2
 * match(Lista1,Lista2) :- Retorna true si Lista1 es Lista2 concatenado
 * con otra lista.
 *
 */

match([],[]).
match(_,[]).
match([X|Y],[Z|W]) :- X==Z, match(Y,W),!.

/*
 * sub/3
 * sub(Lista1,Lista2,Resto) :- Resta Lista1 con Lista2 para obtener
 * los elementos que hacen diferencia en Resto
 *
 */

sub(List,[],List).
sub(List,[X|Sub],Resto) :- select(X,List,Resto0), sub(Resto0,Sub,Resto).


/*
 * pairsValues/2
 * pairsValues(ListaTuplas,Lista) :- Separa las tuplas de la lista ListaTuplas
 *
 */
pairsValues([], []).
pairsValues([_-V|T0], [V|T]) :- pairsValues(T0, T).

/*
 * elemento/2
 * elemento(Elemento, Lista) :- Elemento pertenece a Lista.
 */
not(elemento(_, [])).
elemento(Elemento, [Cabeza|Cola]) :-
  (Elemento = Cabeza;
  elemento(Elemento, Cola)),
  !.

/*
 * esGenero/2
 * esGenero(Anime, Genero) :- Anime es anime (válido) del género válido Genero.
 */
esGenero(Anime, Genero) :-
  anime(Anime),
  genero(Genero),
  generoAnime(Anime, Lista),
  elemento(Genero, Lista).

/*
 * agregarAnime/1
 * agregarAnime(Anime) :- Si no existe la entrada anime(Anime) en la base de
 *                        conocimiento se añade a la base de conocimiento.
 */
agregarAnime(Anime) :-
  \+(anime(Anime)),
  assertz(anime(Anime)).

/*
 * agregarGenero/1
 * agregarGenero(Genero) :- Si no existe la entrada genero(Genero) en la base
 *                          de conocimiento se añade a la base de conocimiento.
 */
agregarGenero(Genero) :-
  \+(genero(Genero)),
  assertz(genero(Genero)).

/*
 * agregarGeneroAnime/2
 * agregarGeneroAnime(Anime, Genero) :-
 *   Si Anime y Genero son anime y género válidos y, no existe la entrada
 *   generoAnime(Anime, Lista) en la base de conocimiento o, Genero no está en
 *   Lista, entonces se añade a la base de conocimiento.
 *   La verificación de generoAnime se hace mediante los predicados auxiliares:
 *     - esGenero/2.
 */
agregarGeneroAnime(Anime, Genero) :-
  anime(Anime),
  genero(Genero),
  \+(esGenero(Anime, Genero)),
  (
    (
      \+(generoAnime(Anime, _Lista)),
      assertz(generoAnime(Anime, [Genero])),
      !
    );
    (
      generoAnime(Anime, Lista),
      \+(elemento(Genero, Lista)),
      retract(generoAnime(Anime, [Cabeza|Cola])),
      assertz(generoAnime(Anime, [Genero, Cabeza|Cola])),
      !
    )
  ).

/*
 * agregarRating/2
 * agregarRating(Anime, Estrellas) :-
 *   Si Anime es un anime válido y Estrellas es un número en [1..5] no existe
 *   la entrada rating(Anime, Estrellas), entonces la agrega a la base de
 *   conocimiento.
 */
 agregarRating(Anime, Estrellas) :-
  anime(Anime),
  0 < Estrellas,
  Estrellas < 6,
  \+(rating(Anime, _)),
  assertz(rating(Anime, Estrellas)).

/*
 * agregarPopularidad/2
 * agregarPopularidad(Anime, Popularidad) :-
 *   Si Anime es un anime válido y Popularidad es un número en [1..10] y
 *   además, existe la entrada popularidad(Anime, Popularidad) en la base de
 *   conocimiento o, en caso contrario, la agrega a la base de conocimiento.
 */
agregarPopularidad(Anime, Popularidad) :-
  anime(Anime),
  0 < Popularidad,
  Popularidad < 11,
  \+(popularidad(Anime, _)),
  assertz(popularidad(Anime, Popularidad)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Predicados De La Base %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 * anime/1
 * anime(Anime) :- Anime es un anime.
 * No hay forma de saber si un nombre dado corresponde a un Anime, esto debe
 * estar explícito en la base conocimiento.
 */

:- dynamic anime/1.
anime('Another').
anime('Anyone You Can Do').
anime('Bleach').
anime('Bible Black').
anime('Blood C').
anime('Blood +').
anime('Boku No Pico').
anime('Boruto').
anime('Cafe Junkies').
anime('Candy Candy').
anime('Clannad').
anime('Code Geass').
anime('Cowboy Bebop').
anime('Corrector Yui').
anime('Death Note').
anime('Digimon Adventure 02').
anime('Digimon Adventure Tri').
anime('Digimon Adventure').
anime('Digimon Frontier').
anime('Digimon Savers').
anime('Digimon Tamers').
anime('Digimon XROS Wars').
anime('Doraemon').
anime('Dragon Ball GT').
anime('Dragon Ball Super').
anime('Dragon Ball Z Kai').
anime('Dragon Ball Z').
anime('Dragon Ball').
anime('Elfen Lied').
anime('Fairy Tail').
anime('Fruits Basket').
anime('FullMetal Alchemist Brotherhood').
anime('FullMetal Alchemist').
anime('FullMetal Panic Fumoffu').
anime('Gantz').
anime('Genma Wars').
anime('Gintama').
anime('Golden Boy').
anime('Gundam').
anime('Gundam Wing').
anime('Hamtaro').
anime('Hellsing').
anime('Heidi').
anime('Hunter x Hunter').
anime('InuYasha').
anime('Jigoku Sensei Nube').
anime('Junjou Romantica').
anime('Love Hina').
anime('Magi').
anime('Magi: Sinbad No Bokuen').
anime('Magical Doremi').
anime('Matantei Loki Ragnarok').
anime('Mazinger Z').
anime('Medabots').
anime('Megaman').
anime('Mirai Nikki').
anime('Mizugi Kanojo').
anime('Nanatsu No Taizai').
anime('Naruto').
anime('Naruto: Shippuuden').
anime('Neon Genesis Evangelion').
anime('One Piece').
anime('Planet Survival').
anime('Pokemon').
anime('Ruroni Kenshin').
anime('Saikano').
anime('Sailor Moon').
anime('Saint Seiya Omega').
anime('Saint Seiya The Lost Canvas').
anime('Saint Seiya').
anime('Sakura Card Captors').
anime('Samurai 7').
anime('Samurai Champloo').
anime('Sensitive Pornograph').
anime('Shingeki No Kyoujin').
anime('Slam Dunk').
anime('Strawberry Panic').
anime('Super Campeones').
anime('Sword Art Online').
anime('The Prince Of Tennis').
anime('The Twelve Kingdoms').
anime('Toukyou Requiem').
anime('Yu Gi Oh!').
anime('Yu Yu Hakusho').
anime('Zenki').

/*
 * genero/1
 * genero(Genero) :- Genero es un género de anime.
 * No hay forma de saber si un nombre dado corresponde a un género de anime,
 * esto debe estar explícito en la base conocimiento.
 */

:- dynamic genero/1.

genero('Comedia').
genero('Cyberpunk').
genero('Ecchi').
genero('Gekiga').
genero('Gore').
genero('Harem Inverso').
genero('Harem').
genero('Hentai').
genero('Jidaigeki').
genero('Josei').
genero('Kemono').
genero('Kodomo').
genero('Lolicon').
genero('Mahou Shoujo').
genero('Mecha').
genero('Meitantei').
genero('Nekketsu').
genero('Post-apocaliptico').
genero('Romakome').
genero('Seinen').
genero('Sentai').
genero('Shotacon').
genero('Shoujo').
genero('Shounen').
genero('Spokon').
genero('Steampunk').
genero('Suspenso').
genero('Yuri').
genero('Yaoi').

/*
 * generoAnime/2
 * generoAnime(Anime, ListaGenero) :- A es un anime y todo género en Lg es un
 * género válido
 * de anime.
 */

:- dynamic generoAnime/2.

generoAnime('Another', ['Seinen', 'Gore']).
generoAnime('Bleach', ['Shounen', 'Nekketsu']).
generoAnime('Bible Black', ['Hentai']).
generoAnime('Blood C', ['Shounen', 'Gore']).
generoAnime('Blood +', ['Shounen', 'Gore']).
generoAnime('Boruto', ['Shounen', 'Nekketsu']).
generoAnime('Candy Candy', ['Shoujo', 'Romakome']).
generoAnime('Clannad', ['Shoujo']).
generoAnime('Code Geass', ['Shounen', 'Mecha']).
generoAnime('Cowboy Bebop', ['Shounen', 'Post-apocaliptico']).
generoAnime('Corrector Yui', ['Shoujo', 'Mahou Shoujo']).
generoAnime('Death Note', ['Shounen', 'Meitantei']).
generoAnime('Digimon Adventure 02', ['Shounen', 'Nekketsu']).
generoAnime('Digimon Adventure Tri', ['Shounen', 'Nekketsu']).
generoAnime('Digimon Adventure', ['Shounen', 'Nekketsu']).
generoAnime('Digimon Frontier', ['Shounen', 'Nekketsu']).
generoAnime('Digimon Savers', ['Shounen', 'Nekketsu']).
generoAnime('Digimon Tamers', ['Shounen', 'Nekketsu']).
generoAnime('Digimon XROS Wars', ['Shounen', 'Nekketsu']).
generoAnime('Doraemon', ['Kodomo', 'Comedia']).
generoAnime('Dragon Ball GT', ['Shounen', 'Nekketsu']).
generoAnime('Dragon Ball Super', ['Shounen', 'Nekketsu']).
generoAnime('Dragon Ball Z Kai', ['Shounen', 'Nekketsu']).
generoAnime('Dragon Ball Z', ['Shounen', 'Nekketsu']).
generoAnime('Dragon Ball', ['Shounen', 'Nekketsu']).
generoAnime('Elfen Lied', ['Seinen', 'Gore', 'Romakome']).
generoAnime('Fairy Tail', ['Shounen', 'Nekketsu', 'Comedia']).
generoAnime('Fruits Basket', ['Shoujo', 'Harem Inverso', 'Comedia', 'Romakome']).
generoAnime('FullMetal Alchemist Brotherhood', ['Shounen', 'Nekketsu', 'Steampunk']).
generoAnime('FullMetal Alchemist', ['Shounen', 'Nekketsu', 'Steampunk']).
generoAnime('FullMetal Panic Fumoffu', ['Shounen', 'Comedia', 'Romakome']).
generoAnime('Gantz', ['Seinen', 'Gore']).
generoAnime('Genma Wars', ['Shounen']).
generoAnime('Gintama', ['Shounen', 'Comedia']).
generoAnime('Golden Boy', ['Seinen', 'Harem', 'Comedia']).
generoAnime('Gundam', ['Shounen', 'Mecha']).
generoAnime('Gundam Wing', ['Shounen', 'Mecha']).
generoAnime('Hamtaro', ['Kodomo', 'Comedia']).
generoAnime('Hellsing', ['Seinen', 'Gore']).
generoAnime('Heidi', ['Kodomo']).
generoAnime('Hunter x Hunter', ['Shounen', 'Nekketsu']).
generoAnime('InuYasha', ['Shounen', 'Nekketsu', 'Kemono', 'Romakome']).
generoAnime('Jigoku Sensei Nube', ['Shounen', 'Comedia']).
generoAnime('Junjou Romantica', ['Shoujo', 'Yaoi', 'Comedia', 'Romakome']).
generoAnime('Love Hina', ['Shounen', 'Harem', 'Romakome', 'Comedia']).
generoAnime('Magi', ['Shounen', 'Nekketsu']).
generoAnime('Magi: Sinbad No Bokuen', ['Shounen', 'Nekketsu']).
generoAnime('Magical Doremi', ['Shoujo', 'Mahou Shoujo']).
generoAnime('Matantei Loki Ragnarok', ['Shounen', 'Meitantei', 'Comedia', 'Romakome']).
generoAnime('Mazinger Z', ['Shounen', 'Mecha']).
generoAnime('Medabots', ['Shounen', 'Mecha', 'Comedia']).
generoAnime('Mega Man', ['Shounen', 'Sentai']).
generoAnime('Mirai Nikki', ['Shounen', 'Gore']).
generoAnime('Mizugi Kanojo', ['Hentai']).
generoAnime('Nanatsu No Taizai', ['Shounen', 'Nekketsu', 'Ecchi', 'Comedia']).
generoAnime('Naruto', ['Shounen', 'Nekketsu', 'Comedia']).
generoAnime('Naruto: Shippuuden', ['Shounen', 'Nekketsu', 'Comedia']).
generoAnime('Neon Genesis Evangelion', ['Shounen', 'Mecha']).
generoAnime('One Piece', ['Shounen', 'Nekketsu']).
generoAnime('Planet Survival', ['Shounen', 'Mahou Shoujo', 'Harem']).
generoAnime('Pokemon', ['Shounen', 'Nekketsu']).
generoAnime('Ruroni Kenshin', ['Shounen', 'Nekketsu', 'Jidaigeki']).
generoAnime('Saikano', ['Seinen', 'Romakome']).
generoAnime('Sailor Moon', ['Shoujo', 'Mahou Shoujo']).
generoAnime('Saint Seiya Omega', ['Shounen', 'Nekketsu']).
generoAnime('Saint Seiya The Lost Canvas', ['Shounen', 'Nekketsu']).
generoAnime('Saint Seiya', ['Shounen', 'Nekketsu']).
generoAnime('Sakura Card Captors', ['Shoujo', 'Mahou Shoujo']).
generoAnime('Samurai 7', ['Shounen', 'Nekketsu']).
generoAnime('Samurai Champloo', ['Shounen', 'Nekketsu', 'Jidaigeki']).
generoAnime('Sensitive Pornograph', ['Hentai', 'Yaoi', 'Romakome']).
generoAnime('Shingeki No Kyoujin', ['Shounen', 'Post-apocaliptico']).
generoAnime('Slam Dunk', ['Shounen', 'Spokon']).
generoAnime('Strawberry Panic', ['Seinen', 'Yuri', 'Romakome']).
generoAnime('Super Campeones', ['Shounen', 'Spokon']).
generoAnime('Sword Art Online', ['Shounen', 'Nekketsu', 'Romakome']).
generoAnime('The Prince Of Tennis', ['Shounen', 'Spokon']).
generoAnime('The Twelve Kingdoms', ['Shoujo']).
generoAnime('Toukyou Requiem', ['Hentai']).
generoAnime('Yu Yu Hakusho', ['Shounen', 'Nekketsu', 'Comedia']).
generoAnime('Yu Gi Oh!', ['Shounen', 'Nekketsu']).
generoAnime('Zenki', ['Shounen', 'Nekketsu']).

/*
 * rating/2
 * rating(Anime, Estrellas) :- Anime es un anime y 0 < Estrellas < 6.
 */

:- dynamic rating/2.
rating('Another', 3).
rating('Bleach', 5).
rating('Bible Black', 4).
rating('Blood C', 9).
rating('Blood +', 3).
rating('Boruto', 3).
rating('Candy Candy', 3).
rating('Clannad', 3).
rating('Code Geass', 3).
rating('Cowboy Bebop', 3).
rating('Corrector Yui', 3).
rating('Death Note', 5).
rating('Digimon Adventure 02', 5).
rating('Digimon Adventure Tri', 5).
rating('Digimon Adventure', 5).
rating('Digimon Frontier', 5).
rating('Digimon Savers', 5).
rating('Digimon Tamers', 5).
rating('Digimon XROS Wars', 3).
rating('Doraemon', 3).
rating('Dragon Ball GT', 5).
rating('Dragon Ball Super', 5).
rating('Dragon Ball Z Kai', 5).
rating('Dragon Ball Z', 5).
rating('Dragon Ball', 3).
rating('Elfen Lied', 3).
rating('Fairy Tail', 5).
rating('Fruits Basket', 3).
rating('FullMetal Alchemist Brotherhood', 5).
rating('FullMetal Alchemist', 4).
rating('FullMetal Panic Fumoffu', 3).
rating('Gantz', 5).
rating('Genma Wars', 5).
rating('Gintama', 3).
rating('Golden Boy', 3).
rating('Gundam', 3).
rating('Gundam Wing', 3).
rating('Hamtaro', 4).
rating('Hellsing', 5).
rating('Heidi', 3).
rating('Hunter x Hunter', 4).
rating('InuYasha', 5).
rating('Jigoku Sensei Nube', 3).
rating('Junjou Romantica', 3).
rating('Love Hina', 3).
rating('Magi', 3).
rating('Magi: Sinbad No Bokuen', 3).
rating('Magical Doremi', 3).
rating('Matantei Loki Ragnarok', 2).
rating('Mazinger Z', 1).
rating('Medabots', 2).
rating('Megaman', 2).
rating('Mirai Nikki', 5).
rating('Mizugi Kanojo', 4).
rating('Nanatsu No Taizai', 5).
rating('Naruto', 5).
rating('Naruto: Shippuden', 5).
rating('Neon Genesis Evangelion', 5).
rating('One Piece', 5).
rating('Planet Survival', 2).
rating('Pokemon', 5).
rating('Ruroni Kenshin', 5).
rating('Saikano', 2).
rating('Sailor Moon', 5).
rating('Saint Seiya Omega', 3).
rating('Saint Seiya The Lost Canvas', 5).
rating('Saint Seiya', 5).
rating('Sakura Card Captors', 5).
rating('Samurai 7', 3).
rating('Samurai Champloo', 3).
rating('Sensitive Pornograph', 4).
rating('Shingeki No Kyoujin', 3).
rating('Slam Dunk', 3).
rating('Strawberry Panic', 3).
rating('Super Campeones', 3).
rating('Sword Art Online', 5).
rating('The Prince Of Tennis', 4).
rating('The Twelve Kingdoms', 1).
rating('Toukyou Requiem', 4).
rating('Yu Gi Oh!', 5).
rating('Yu Yu Hakusho', 5).
rating('Zenki', 3).

/*
 * popularidad/2
 * popularidad(Anime, Popularidad) :- Anime es un anime y 0 < Popularidad < 11.
 */

:- dynamic popularidad/2.
popularidad('Another', 8).
popularidad('Anyone You Can Do', 4).
popularidad('Bleach', 8).
popularidad('Bible Black', 4).
popularidad('Blood C', 3).
popularidad('Blood +', 3).
popularidad('Boku No Pico', 10).
popularidad('Boruto', 9).
popularidad('Cafe Junkies', 4).
popularidad('Candy Candy', 2).
popularidad('Clannad', 6).
popularidad('Code Geass', 7).
popularidad('Cowboy Bebop', 7).
popularidad('Corrector Yui', 7).
popularidad('Death Note', 9).
popularidad('Digimon Adventure 02', 10).
popularidad('Digimon Adventure Tri', 10).
popularidad('Digimon Adventure', 10).
popularidad('Digimon Frontier', 10).
popularidad('Digimon Savers', 10).
popularidad('Digimon Tamers', 10).
popularidad('Digimon XROS Wars', 7).
popularidad('Doraemon', 7).
popularidad('Dragon Ball GT', 10).
popularidad('Dragon Ball Super', 10).
popularidad('Dragon Ball Z Kai', 10).
popularidad('Dragon Ball Z', 10).
popularidad('Dragon Ball', 10).
popularidad('Elfen Lied', 8).
popularidad('Fairy Tail', 9).
popularidad('Fruits Basket', 4).
popularidad('FullMetal Alchemist Brotherhood', 6).
popularidad('FullMetal Alchemist', 6).
popularidad('FullMetal Panic Fumoffu', 2).
popularidad('Gantz', 4).
popularidad('Genma Wars', 1).
popularidad('Gintama', 6).
popularidad('Golden Boy', 1).
popularidad('Gundam', 1).
popularidad('Gundam Wing', 3).
popularidad('Hamtaro', 6).
popularidad('Hellsing', 7).
popularidad('Heidi', 1).
popularidad('Hunter x Hunter', 7).
popularidad('InuYasha', 9).
popularidad('Jigoku Sensei Nube', 6).
popularidad('Junjou Romantica', 5).
popularidad('Love Hina', 4).
popularidad('Magi', 7).
popularidad('Magi: Sinbad No Bokuen', 7).
popularidad('Magical Doremi', 7).
popularidad('Matantei Loki Ragnarok', 1).
popularidad('Mazinger Z', 1).
popularidad('Medabots', 1).
popularidad('Megaman', 1).
popularidad('Mirai Nikki', 4).
popularidad('Mizugi Kanojo', 4).
popularidad('Nanatsu No Taizai', 7).
popularidad('Naruto', 10).
popularidad('Naruto: Shippuden', 10).
popularidad('Neon Genesis Evangelion', 10).
popularidad('One Piece', 10).
popularidad('Planet Survival', 2).
popularidad('Pokemon', 10).
popularidad('Ruroni Kenshin', 8).
popularidad('Saikano', 1).
popularidad('Sailor Moon', 9).
popularidad('Saint Seiya Omega', 7).
popularidad('Saint Seiya The Lost Canvas', 7).
popularidad('Saint Seiya', 8).
popularidad('Sakura Card Captors', 7).
popularidad('Samurai 7', 3).
popularidad('Samurai Champloo', 3).
popularidad('Sensitive Pornograph', 4).
popularidad('Shingeki No Kyoujin', 8).
popularidad('Slam Dunk', 7).
popularidad('Strawberry Panic', 7).
popularidad('Super Campeones', 7).
popularidad('Sword Art Online', 8).
popularidad('The Prince Of Tennis', 5).
popularidad('The Twelve Kingdoms', 1).
popularidad('Toukyou Requiem', 4).
popularidad('Yu Gi Oh!', 10).
popularidad('Yu Yu Hakusho', 10).
popularidad('Zenki', 7).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Predicados Requeridos %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 * Mostrar animes de un genero ordenados por rating o popularidad creciente o
 * decreciente (por defecto).
 *
 * Se definen los predicados:
 *   - porRating/2.
 *   - porPopularidad/2.
 *   - combinada/2.
 */

/*
 * porRating/2
 * Muestra los anime Anime del género Genero, en la lista ordenada Lista
 * decrecientemente en función del rating Estrellas de Anime.
 */
porRating(Genero, Lista) :-
  findall(
    Estrellas-Anime,
    (
      rating(Anime, Estrellas),
      generoAnime(Anime, ListaGenero),
      elemento(Genero, ListaGenero)
    ),
    ListaAux),
  sort(1,@>=,ListaAux, ListaAux2),
  pairsValues(ListaAux2, Lista).

/* 
 * porRatingInverso/2
 * Variante en orden creciente
 */
porRatingInverso(Genero, Salida) :- porRating(Genero,Lista),reverse(Lista,Salida,[]).

/*
 * porPopularidad/2
 * Muestra los anime Anime del género Genero, en la lista ordenada Lista
 * decrecientemente en función de la popularidad Popularidad de Anime.
 */
porPopularidad(Genero, Lista) :-
  findall(Popularidad-Anime, (
    popularidad(Anime, Popularidad),
    generoAnime(Anime, ListaGenero),
    elemento(Genero, ListaGenero)
  ), ListaAux),
  sort(1,@>=,ListaAux, ListaAux2),
  pairsValues(ListaAux2, Lista).

/* 
 * porPopularidadInverso/2
 * Variante en orden creciente
 */
porPopularidadInverso(Genero, Salida) :- porPopularidad(Genero,Lista),reverse(Lista,Salida,[]).

/*
 * combinada/2
 * Muestra los anime Anime del Genero Genero, en la lista ordenada Lista
 * decrecientemente en función del valor Valor que es la suma de la
 * popularidad Popularidad y el rating Estrellas de Anime.
 */
combinada(Genero, Lista) :-
  findall(Valor-Anime, (
    generoAnime(Anime, ListaGenero),
    elemento(Genero, ListaGenero),
    popularidad(Anime, Popularidad),
    rating(Anime, Estrellas),
    Valor is Popularidad + Estrellas
  ), ListaAux),
  sort(1,@>=,ListaAux, ListaAux2),
  pairsValues(ListaAux2, Lista).

/* 
 * combinadaInverso/2
 * Variante en orden creciente
 */
combinadaInverso(Genero, Salida) :- combinada(Genero,Lista),reverse(Lista,Salida,[]).

/*
 * Mostar los anime con X número de estrellas dentro de cierto género.
 *
 * ratingGenero/3
 * ratingGenero(Genero, Estrellas, Lista) :- la lista Lista de todos los
 * anime Anime del género Genero y rating Estrellas.
 */

ratingGenero(Genero, Estrellas, Lista) :-
  findall(
    Anime,
    (
      esGenero(Anime, Genero),
      rating(Anime, Estrellas)
    ),
    Lista
  ).

/*
 * delGenero/2
 * delGenero(X,Lista) :- Consigue los anime del género X y los
 * coloca en Lista
 */

delGenero(X,Lista) :-
    findall(Genero-Anime, (generoAnime(Anime,Genero), member(X,Genero)), Lista),!.

/*
 * Poder mostrar los anime buenos poco conocidos.
 *
 * Anime bueno es aquel cuyo rating es mayor a 3 (no especificado)
 * Anime poco conocido es aquel cuya popularidad es menor a 6 (por enunciado).
 *
 * buenosPorConocer/1
 * buenosPorConocer(Lista) :- la lista Lista de los anime con rating Estrellas
 * mayor a 3 y popularidad Popularidad menor a 6.
 */

buenosPorConocer(Lista) :-
  findall(Anime-Popularidad-Estrellas, (
    rating(Anime, Estrellas),
    popularidad(Anime, Popularidad),
    Estrellas > 3,
    Popularidad < 6
  ),
  Lista).

/* 
 * muyPocoConocidos/1
 * muyPocoConocidos(Lista) :- la lista Lista de los anime 
 * con popularidad entre 1 y 2 y estrellas mayor a 3.
 *
 */

muyPocoConocidos(Lista) :-
  findall(Anime-Popularidad-Estrellas, (
    rating(Anime, Estrellas),
    popularidad(Anime, Popularidad),
    between(1,2,Popularidad),
    Estrellas > 3
  ),
  Lista).

/* 
 * pocoConocidos/1
 * pocoConocidos(Lista) :- la lista Lista de los anime 
 * con popularidad entre 3 y 5 y estrellas mayor a 3.
 *
 */
pocoConocidos(Lista) :-
  findall(Anime-Popularidad-Estrellas, (
    rating(Anime, Estrellas),
    popularidad(Anime, Popularidad),
    between(3,5,Popularidad),
    Estrellas > 3
  ),
  Lista).

/* 
 * conocidos/1
 * conocidos(Lista) :- la lista Lista de los anime 
 * con popularidad entre 6 y 7 y estrellas mayor a 3.
 *
 */
conocidos(Lista) :-
  findall(Anime-Popularidad-Estrellas, (
    rating(Anime, Estrellas),
    popularidad(Anime, Popularidad),
    between(6,7,Popularidad),
    Estrellas > 3
  ),
  Lista).

/* 
 * muyConocidos/1
 * muyConocidos(Lista) :- la lista Lista de los anime 
 * con popularidad entre 6 y 7 y estrellas mayor a 3.
 *
 */

muyConocidos(Lista) :-
  findall(Anime-Popularidad-Estrellas, (
    rating(Anime, Estrellas),
    popularidad(Anime, Popularidad),
    between(8,9,Popularidad),
    Estrellas > 3
  ),
  Lista).

/* 
 * bastanteConocidos/1
 * bastanteConocidos(Lista) :- la lista Lista de los anime 
 * con popularidad igual a 10 y estrellas mayor a 3.
 */

bastanteConocidos(Lista) :-
  findall(Anime-Popularidad-Estrellas, (
    rating(Anime, Estrellas),
    popularidad(Anime, Popularidad),
    Popularidad == 10,
    Estrellas > 3
  ),
  Lista).

/*
 * Poder agregar a la base de datos un anime con su género y rating, si no
 * está en la misma. La popularidad es opcional especificarla al agregarlo y
 * por defecto es 1.
 *
 * Se definen los predicados:
 *    agregarConPopularidad/4.
 *    agregarSinPopularidad/3.
 *
 */

/*
 * agregarConPopularidad/4
 * agregarConPopularidad(Anime, Genero, Estrellas, Popularidad) :- añadir a
 * la base de conocimientos al anime Anime cuyo género, rating y popularidad
 * es, respectivamente Genero, Estrellas y Popularidad. 
 */

:- dynamic agregarConPopularidad/4.

agregarConPopularidad(Anime, Genero, Estrellas, Popularidad) :-
  agregarAnime(Anime),
  agregarRating(Anime, Estrellas),
  agregarPopularidad(Anime, Popularidad),
  agregarGeneroAnime(Anime, Genero).

/*
 * agregarSinPopularidad/3
 * agregarSinPopularidad(Anime, Genero, Estrellas) :- añadir a la base de
 * conocimientos al anime Anime cuyo género y rating es, respectivamente
 * Genero y Estrellas. 
 */

:- dynamic agregarSinPopularidad/3.

agregarSinPopularidad(Anime, Genero, Estrellas) :-
  agregarAnime(Anime),
  agregarGeneroAnime(Anime, Genero),
  agregarRating(Anime, Estrellas),
  agregarPopularidad(Anime, 1).

/*
 * Subir la popularidad del anime si los usuarios preguntan por él 5 o más
 * veces.
 *
 * subirPopularidad/1
 * subirPopularidad(Anime) :- Si y solo si la popularidad del anime Anime es
 * menor que 10, entonces borra la entrada correspondienta a su popularidad en
 * la base de conocimientos y agrega una nueva entrada de popularidad con la
 * popularidad incrementada en 1.
 * Si la popularidad es 10, entonces no hace nada.
 */


:- dynamic subirPopularidad/1.
subirPopularidad(Anime) :-
  anime(Anime),
  popularidad(Anime, Popularidad),
  Popularidad < 10,
  retract(popularidad(Anime, Popularidad)),
  NuevaPopularidad is Popularidad + 1,
  assertz(popularidad(Anime, NuevaPopularidad)).


/*
 * count/2
 * count(Anime,0) :- Comienza el contador de consultas en 0
 * para todo anime.
 */

:- dynamic count/2.
count([],0).
count(X,0) :- anime(X).

/*
 * agregaConsulta/1
 * agregaConsulta(Anime) :- Cuenta las consultas hechas al anime Anime
 * y sube su popularidad al sumarse 5 consultas al mismo anime.
 */

:- dynamic agregaConsulta/1.
agregaConsulta(Anime) :-
  (count(Anime,0), retractall(count(Anime,_X)), assertz(count(Anime,1)),!);
  (count(Anime,1), retractall(count(Anime,_X)), assertz(count(Anime,2)),!);
  (count(Anime,2), retractall(count(Anime,_X)), assertz(count(Anime,3)),!);
  (count(Anime,3), retractall(count(Anime,_X)), assertz(count(Anime,4)),!);
  ((count(Anime,4), retractall(count(Anime,_X)), assertz(count(Anime,0)),!),
    subirPopularidad(Anime)).