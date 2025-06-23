-- POBLACIÓN DE DATOS PARA MODELO OBJETUAL
-- Inserción de datos usando tipos compuestos y herencia

-- Insertar directores
INSERT INTO obj_cine.director (
    nombre, 
    info_personal, 
    biografia, 
    estilo_direccion, 
    peliculas_dirigidas, 
    premios_direccion, 
    escuela_cine
) VALUES 
(
    'Giuseppe Tornatore',
    ROW(
        '1956-05-27',
        'Bagheria, Sicilia, Italia',
        'Casado',
        ROW('+39-091-123456', 'gtornatore@email.com', 'Via Roma 123, Bagheria, Italia')
    ),
    'Cineasta italiano conocido por sus obras nostálgicas y poéticas que exploran temas de memoria, tiempo y cine.',
    'Realismo poético con elementos nostálgicos',
    0, -- Se actualizará automáticamente con el trigger
    ARRAY['Palma de Oro - Cannes', 'Oscar Mejor Película Extranjera'],
    'Centro Sperimentale di Cinematografia'
),
(
    'Federico Fellini',
    ROW(
        '1920-01-20',
        'Rimini, Italia',
        'Casado',
        ROW('+39-06-234567', 'ffellini@email.com', 'Via Veneto 456, Roma, Italia')
    ),
    'Uno de los directores más influyentes del cine italiano, conocido por su estilo surrealista y personal.',
    'Surrealismo cinematográfico',
    0,
    ARRAY['Palma de Oro - Cannes', 'Oscar Honorífico', 'León de Oro - Venecia'],
    'Autodicacta'
),
(
    'Roberto Benigni',
    ROW(
        '1952-10-27',
        'Manciano La Misericordia, Italia',
        'Casado',
        ROW('+39-055-345678', 'rbenigni@email.com', 'Piazza Signoria 789, Firenze, Italia')
    ),
    'Actor, director y guionista italiano conocido por combinar comedia y drama en sus obras.',
    'Comedia dramática humanista',
    0,
    ARRAY['Oscar Mejor Actor', 'Oscar Mejor Película Extranjera'],
    'Teatro experimental'
);

-- Insertar productores
INSERT INTO obj_cine.productor (
    nombre,
    info_personal,
    biografia,
    info_produccion,
    empresa_productora,
    tipo_productor,
    proyectos_activos
) VALUES
(
    'Franco Cristaldi',
    ROW(
        '1924-10-03',
        'Turín, Italia',
        'Casado',
        ROW('+39-06-111222', 'fcristaldi@email.com', 'Via del Corso 100, Roma, Italia')
    ),
    'Productor cinematográfico italiano, fundador de Vides Cinematografica.',
    ROW(8500000.00, 65.00, 'Inversión directa'),
    'Vides Cinematografica',
    'Ejecutivo',
    0
),
(
    'Giovanna Romagnoli',
    ROW(
        '1935-09-15',
        'Roma, Italia',
        'Casada',
        ROW('+39-06-222333', 'gromagnoli@email.com', 'Via Nazionale 200, Roma, Italia')
    ),
    'Productora asociada especializada en cine de autor italiano.',
    ROW(3200000.00, 35.00, 'Coproducción'),
    'Romagnoli Films',
    'Asociada',
    0
),
(
    'Dino De Laurentiis',
    ROW(
        '1919-08-08',
        'Torre Annunziata, Italia',
        'Casado',
        ROW('+39-06-333444', 'ddelaurentiis@email.com', 'Via Appia 300, Roma, Italia')
    ),
    'Productor cinematográfico italiano, uno de los más exitosos de la historia del cine.',
    ROW(15000000.00, 80.00, 'Inversión directa'),
    'De Laurentiis Entertainment Group',
    'Ejecutivo',
    0
);

-- Insertar actores con información financiera
INSERT INTO obj_cine.actor (
    nombre,
    info_personal,
    biografia,
    info_financiera,
    especialidad,
    años_experiencia,
    tipo_actuacion
) VALUES
(
    'Salvatore Cascio',
    ROW(
        '1979-11-08',
        'Palazzo Adriano, Sicilia, Italia',
        'Casado',
        ROW('+39-090-111222', 'scascio@email.com', 'Via Garibaldi 10, Palazzo Adriano, Italia')
    ),
    'Actor italiano que debutó como niño en Cinema Paradiso.',
    ROW(1200000.00, 150000.00, 1350000.00),
    'Actor infantil y juvenil',
    15,
    ARRAY['Protagonista', 'Drama']
),
(
    'Marco Leonardi',
    ROW(
        '1971-11-14',
        'Melbourne, Australia',
        'Divorciado',
        ROW('+39-06-222333', 'mleonardi@email.com', 'Via Trastevere 25, Roma, Italia')
    ),
    'Actor italiano-australiano conocido por sus roles en Cinema Paradiso y otras producciones.',
    ROW(1800000.00, 200000.00, 2000000.00),
    'Actor dramático',
    25,
    ARRAY['Protagonista', 'Secundario', 'Drama', 'Romance']
),
(
    'Jacques Perrin',
    ROW(
        '1941-07-13',
        'París, Francia',
        'Casado',
        ROW('+33-01-333444', 'jperrin@email.com', '15 Rue de Rivoli, París, Francia')
    ),
    'Actor y productor francés con una larga carrera en cine europeo.',
    ROW(2500000.00, 300000.00, 2800000.00),
    'Actor veterano',
    45,
    ARRAY['Protagonista', 'Secundario', 'Drama', 'Thriller']
),
(
    'Philippe Noiret',
    ROW(
        '1930-10-01',
        'Lille, Francia',
        'Casado',
        ROW('+33-01-444555', 'pnoiret@email.com', '8 Boulevard Saint-Germain, París, Francia')
    ),
    'Actor francés icónico del cine europeo, conocido por su versatilidad.',
    ROW(3200000.00, 400000.00, 3600000.00),
    'Actor de carácter',
    50,
    ARRAY['Protagonista', 'Drama', 'Comedia']
),
(
    'Brigitte Fossey',
    ROW(
        '1946-06-15',
        'Tourcoing, Francia',
        'Casada',
        ROW('+33-01-555666', 'bfossey@email.com', '22 Avenue des Champs-Élysées, París, Francia')
    ),
    'Actriz francesa conocida desde la infancia, con una carrera sólida en cine europeo.',
    ROW(850000.00, 100000.00, 950000.00),
    'Actriz dramática',
    40,
    ARRAY['Secundario', 'Drama', 'Romance']
),
(
    'Antonella Attili',
    ROW(
        '1963-05-23',
        'Catania, Sicilia, Italia',
        'Casada',
        ROW('+39-090-666777', 'aattili@email.com', 'Via Etnea 50, Catania, Italia')
    ),
    'Actriz italiana especializada en cine de autor siciliano.',
    ROW(750000.00, 80000.00, 830000.00),
    'Actriz regional',
    30,
    ARRAY['Secundario', 'De reparto', 'Drama']
),
(
    'Enzo Cannavale',
    ROW(
        '1928-04-05',
        'Castellammare di Stabia, Italia',
        'Casado',
        ROW('+39-081-777888', 'ecannavale@email.com', 'Via Toledo 75, Nápoles, Italia')
    ),
    'Actor italiano conocido por sus roles cómicos y dramáticos.',
    ROW(680000.00, 70000.00, 750000.00),
    'Actor de carácter',
    35,
    ARRAY['Secundario', 'Comedia', 'Drama']
),
(
    'Leo Gullotta',
    ROW(
        '1946-01-09',
        'Catania, Sicilia, Italia',
        'Casado',
        ROW('+39-095-999000', 'lgullotta@email.com', 'Corso Italia 88, Catania, Italia')
    ),
    'Actor siciliano reconocido por su trabajo en teatro y cine.',
    ROW(600000.00, 60000.00, 660000.00),
    'Actor teatral',
    40,
    ARRAY['De reparto', 'Teatro', 'Drama']
);

-- Insertar más actores para completar 100+
INSERT INTO obj_cine.actor (
    nombre,
    info_personal,
    biografia,
    info_financiera,
    especialidad,
    años_experiencia,
    tipo_actuacion
)
SELECT 
    'Actor Italiano ' || generate_series,
    ROW(
        ('1950-01-01'::date + (generate_series * interval '200 days'))::date,
        'Roma, Italia',
        CASE (generate_series % 4) 
            WHEN 0 THEN 'Soltero'
            WHEN 1 THEN 'Casado'
            WHEN 2 THEN 'Divorciado'
            ELSE 'Viudo'
        END,
        ROW(
            '+39-06-' || LPAD(generate_series::text, 6, '0'),
            'actor' || generate_series || '@email.com',
            'Via Roma ' || generate_series || ', Roma, Italia'
        )
    ),
    'Actor italiano con experiencia en diferentes géneros cinematográficos.',
    ROW(
        (600000 + (generate_series * 50000))::numeric(12,2),
        (50000 + (generate_series * 5000))::numeric(10,2),
        (650000 + (generate_series * 55000))::numeric(12,2)
    ),
    CASE (generate_series % 4)
        WHEN 0 THEN 'Actor dramático'
        WHEN 1 THEN 'Actor cómico'
        WHEN 2 THEN 'Actor de acción'
        ELSE 'Actor de carácter'
    END,
    10 + (generate_series % 30),
    ARRAY[
        CASE (generate_series % 3)
            WHEN 0 THEN 'Protagonista'
            WHEN 1 THEN 'Secundario'
            ELSE 'De reparto'
        END,
        'Drama'
    ]
FROM generate_series(1, 92);

-- Insertar películas con arrays de críticas y premios
INSERT INTO obj_cine.pelicula (
    titulo,
    resumen,
    fecha_estreno,
    ranking,
    duracion_minutos,
    genero,
    idioma_original,
    pais_origen,
    presupuesto,
    recaudacion,
    id_director,
    criticas,
    premios
) VALUES
(
    'Cinema Paradiso',
    'Un hombre maduro recuerda su infancia en un pequeño pueblo siciliano, donde desarrolló una amistad especial con el proyeccionista del cine local. A través de flashbacks, la película explora temas de nostalgia, pérdida de la inocencia y el poder transformador del cine. La historia sigue a Salvatore desde su juventud hasta la edad adulta, mostrando cómo el cine influyó en su vida y cómo las relaciones humanas dan forma a nuestro destino. Es una reflexión poética sobre el paso del tiempo, el amor y la memoria, envuelta en la magia del séptimo arte que conecta generaciones y culturas diferentes, creando un puente emocional entre el pasado y el presente que resuena en el corazón de cada espectador que ha vivido la experiencia transformadora del cine.',
    '1988-11-17',
    4.8,
    155,
    ARRAY['Drama', 'Romance', 'Nostálgico'],
    'Italiano',
    'Italia',
    5000000.00,
    12000000.00,
    (SELECT id_persona FROM obj_cine.director WHERE nombre = 'Giuseppe Tornatore'),
    ARRAY[
        ROW('Mario Sesti', 'La Gazzetta dello Sport', '1990-08-20', 'Una obra maestra del cine italiano que captura la esencia de la nostalgia.', 4.8, 'Muy Positivo')::obj_cine.tipo_critica,
        ROW('Lietta Tornabuoni', 'Corriere della Sera', '1990-08-25', 'Tornatore crea una sinfonía visual de emociones y recuerdos.', 4.7, 'Positivo')::obj_cine.tipo_critica,
        ROW('Tullio Kezich', 'La Repubblica', '1990-08-28', 'Un homenaje al poder del cine y a la memoria colectiva.', 4.9, 'Muy Positivo')::obj_cine.tipo_critica
    ],
    ARRAY[
        ROW('Palma de Oro', 'Festival de Cannes', '1989-05-23', 'Mejor Película', 'Muy Alto')::obj_cine.tipo_premio,
        ROW('Oscar a Mejor Película Extranjera', 'Academia de Hollywood', '1990-03-30', 'Película Extranjera', 'Muy Alto')::obj_cine.tipo_premio,
        ROW('David di Donatello', 'Academia del Cine Italiano', '1989-07-15', 'Mejor Película', 'Alto')::obj_cine.tipo_premio
    ]
),
(
    'La Dolce Vita',
    'Marcello Mastroianni interpreta a un periodista romano que vive una vida hedonista en la alta sociedad de Roma, buscando historias escandalosas mientras navega por relaciones superficiales y encuentros vacíos. La película retrata la decadencia moral de la sociedad italiana de la época, explorando temas de alienación, búsqueda de significado y la corrupción del alma humana. A través de episodios interconectados, Fellini construye un fresco social que critica el materialismo y la pérdida de valores espirituales en la modernidad, utilizando imágenes surrealistas y simbólicas que han marcado la historia del cine mundial, convirtiéndose en un referente cultural que trasciende las fronteras del séptimo arte para influir en la literatura, la filosofía y el arte contemporáneo.',
    '1960-02-05',
    4.7,
    174,
    ARRAY['Drama', 'Surrealista', 'Social'],
    'Italiano',
    'Italia',
    8000000.00,
    25000000.00,
    (SELECT id_persona FROM obj_cine.director WHERE nombre = 'Federico Fellini'),
    ARRAY[
        ROW('André Bazin', 'Cahiers du Cinéma', '1960-03-15', 'Fellini reinventa el lenguaje cinematográfico con esta obra magistral.', 4.9, 'Muy Positivo')::obj_cine.tipo_critica,
        ROW('Pauline Kael', 'The New Yorker', '1961-01-10', 'Una exploración fascinante de la sociedad moderna y sus contradicciones.', 4.6, 'Positivo')::obj_cine.tipo_critica
    ],
    ARRAY[
        ROW('Palma de Oro', 'Festival de Cannes', '1960-05-20', 'Mejor Película', 'Muy Alto')::obj_cine.tipo_premio
    ]
),
(
    'La Vita è Bella',
    'Durante la Segunda Guerra Mundial, un padre judío usa su imaginación y humor para proteger a su hijo de los horrores del Holocausto, convirtiendo su experiencia en un campo de concentración en un juego elaborado. Roberto Benigni crea una obra maestra que combina comedia y drama de manera única, explorando temas de amor paternal, resistencia humana y el poder de la fantasía para superar las tragedias más profundas. La película demuestra cómo el amor puede transformar incluso las circunstancias más terribles, ofreciendo esperanza y dignidad en medio de la desesperación más absoluta, convirtiéndose en un himno a la vida y al espíritu humano indomable que trasciende las barreras culturales y lingüísticas para tocar los corazones de audiencias de todo el mundo con su mensaje universal de amor, sacrificio y esperanza.',
    '1997-12-20',
    4.6,
    116,
    ARRAY['Drama', 'Comedia dramática', 'Guerra'],
    'Italiano',
    'Italia',
    20000000.00,
    230000000.00,
    (SELECT id_persona FROM obj_cine.director WHERE nombre = 'Roberto Benigni'),
    ARRAY[
        ROW('Gian Luigi Rondi', 'Il Tempo', '1998-01-15', 'Benigni logra el milagro de hacer reír y llorar al mismo tiempo.', 4.8, 'Muy Positivo')::obj_cine.tipo_critica
    ],
    ARRAY[
        ROW('Oscar a Mejor Actor', 'Academia de Hollywood', '1999-03-21', 'Mejor Actor', 'Muy Alto')::obj_cine.tipo_premio,
        ROW('Oscar a Mejor Película Extranjera', 'Academia de Hollywood', '1999-03-21', 'Película Extranjera', 'Muy Alto')::obj_cine.tipo_premio
    ]
);

-- Insertar participaciones (relación actor-película)
INSERT INTO obj_cine.participacion (
    id_actor,
    id_pelicula,
    tipo_participacion,
    personaje,
    info_financiera,
    fecha_inicio_rodaje,
    fecha_fin_rodaje,
    notas
) VALUES
-- Cinema Paradiso
((SELECT id_persona FROM obj_cine.actor WHERE nombre = 'Salvatore Cascio'), 1, 'Protagonista', 'Salvatore (niño)', ROW(1200000.00, 150000.00, 1350000.00), '1988-05-01', '1988-08-30', 'Debut cinematográfico'),
((SELECT id_persona FROM obj_cine.actor WHERE nombre = 'Marco Leonardi'), 1, 'Protagonista', 'Salvatore (joven)', ROW(1800000.00, 200000.00, 2000000.00), '1988-05-01', '1988-08-30', 'Papel secundario protagonista'),
((SELECT id_persona FROM obj_cine.actor WHERE nombre = 'Jacques Perrin'), 1, 'Protagonista', 'Salvatore (adulto)', ROW(2500000.00, 300000.00, 2800000.00), '1988-06-15', '1988-07-15', 'Papel narrativo principal'),
((SELECT id_persona FROM obj_cine.actor WHERE nombre = 'Philippe Noiret'), 1, 'Protagonista', 'Alfredo', ROW(3200000.00, 400000.00, 3600000.00), '1988-05-01', '1988-08-30', 'Papel central de la historia'),
((SELECT id_persona FROM obj_cine.actor WHERE nombre = 'Brigitte Fossey'), 1, 'Secundario', 'Elena', ROW(850000.00, 100000.00, 950000.00), '1988-06-01', '1988-07-30', 'Interés romántico'),
((SELECT id_persona FROM obj_cine.actor WHERE nombre = 'Antonella Attili'), 1, 'Secundario', 'Madre de Salvatore', ROW(750000.00, 80000.00, 830000.00), '1988-05-15', '1988-08-15', 'Papel familiar importante'),
((SELECT id_persona FROM obj_cine.actor WHERE nombre = 'Leo Gullotta'), 1, 'De reparto', 'Spaccafico', ROW(600000.00, 60000.00, 660000.00), '1988-07-01', '1988-07-15', 'Personaje del pueblo');

-- Insertar producciones (relación productor-película)
INSERT INTO obj_cine.produccion (
    id_productor,
    id_pelicula,
    info_produccion,
    rol_produccion,
    fecha_inicio,
    fecha_fin
) VALUES
((SELECT id_persona FROM obj_cine.productor WHERE nombre = 'Franco Cristaldi'), 1, ROW(8500000.00, 65.00, 'Inversión directa'), 'Productor Ejecutivo', '1987-12-01', '1988-11-17'),
((SELECT id_persona FROM obj_cine.productor WHERE nombre = 'Giovanna Romagnoli'), 1, ROW(3200000.00, 35.00, 'Coproducción'), 'Productora Asociada', '1987-12-01', '1988-11-17'),
((SELECT id_persona FROM obj_cine.productor WHERE nombre = 'Dino De Laurentiis'), 2, ROW(15000000.00, 80.00, 'Inversión directa'), 'Productor Ejecutivo', '1959-06-01', '1960-02-05');
