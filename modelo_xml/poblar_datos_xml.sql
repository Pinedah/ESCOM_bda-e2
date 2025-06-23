-- POBLACIÓN DE DATOS XML PARA MODELO SEMIESTRUCTURADO
-- Inserción de documentos XML válidos según el esquema XSD

-- Insertar Cinema Paradiso como documento XML completo
INSERT INTO xml_cine.peliculas_xml (titulo, documento_xml) VALUES (
    'Cinema Paradiso',
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <pelicula xmlns="http://escom.ipn.mx/cine" id="1" version_schema="1.0">
        <informacion_basica>
            <titulo>Cinema Paradiso</titulo>
            <resumen>Un hombre maduro recuerda su infancia en un pequeño pueblo siciliano, donde desarrolló una amistad especial con el proyeccionista del cine local. A través de flashbacks, la película explora temas de nostalgia, pérdida de la inocencia y el poder transformador del cine. La historia sigue a Salvatore desde su juventud hasta la edad adulta, mostrando cómo el cine influyó en su vida y cómo las relaciones humanas dan forma a nuestro destino. Es una reflexión poética sobre el paso del tiempo, el amor y la memoria, envuelta en la magia del séptimo arte que conecta generaciones y culturas diferentes, creando un puente emocional entre el pasado y el presente que resuena en el corazón de cada espectador que ha vivido la experiencia transformadora del cine, convirtiéndose en una obra maestra que trasciende las barreras temporales y culturales para tocar la fibra más sensible del alma humana.</resumen>
            <fecha_estreno>1988-11-17</fecha_estreno>
            <ranking>4.8</ranking>
            <duracion_minutos>155</duracion_minutos>
            <idioma_original>Italiano</idioma_original>
            <pais_origen>Italia</pais_origen>
        </informacion_basica>
        
        <clasificacion>
            <genero>Drama</genero>
            <genero>Romance</genero>
            <genero>Nostálgico</genero>
        </clasificacion>
        
        <direccion>
            <director>
                <informacion_personal id="1">
                    <nombre>Giuseppe Tornatore</nombre>
                    <fecha_nacimiento>1956-05-27</fecha_nacimiento>
                    <lugar_nacimiento>Bagheria, Sicilia, Italia</lugar_nacimiento>
                    <estado_civil>Casado</estado_civil>
                    <contacto>
                        <telefono>+39-091-123456</telefono>
                        <email>gtornatore@email.com</email>
                        <direccion>Via Roma 123, Bagheria</direccion>
                        <ciudad>Bagheria</ciudad>
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Cineasta italiano conocido por sus obras nostálgicas y poéticas que exploran temas de memoria, tiempo y cine.</biografia>
                </informacion_personal>
                <estilo_direccion>Realismo poético con elementos nostálgicos</estilo_direccion>
                <escuela_cine>Centro Sperimentale di Cinematografia</escuela_cine>
                <años_experiencia>35</años_experiencia>
                <premios_direccion>
                    <premio>Palma de Oro - Cannes</premio>
                    <premio>Oscar Mejor Película Extranjera</premio>
                </premios_direccion>
            </director>
        </direccion>
        
        <reparto>
            <participacion>
                <actor>
                    <informacion_personal id="6">
                        <nombre>Salvatore Cascio</nombre>
                        <fecha_nacimiento>1979-11-08</fecha_nacimiento>
                        <lugar_nacimiento>Palazzo Adriano, Sicilia, Italia</lugar_nacimiento>
                        <estado_civil>Casado</estado_civil>
                        <contacto>
                            <telefono>+39-090-111222</telefono>
                            <email>scascio@email.com</email>
                            <direccion>Via Garibaldi 10</direccion>
                            <ciudad>Palazzo Adriano</ciudad>
                            <pais>Italia</pais>
                        </contacto>
                        <biografia>Actor italiano que debutó como niño en Cinema Paradiso.</biografia>
                    </informacion_personal>
                    <informacion_financiera>
                        <salario_base>1200000.00</salario_base>
                        <bonificaciones>150000.00</bonificaciones>
                        <salario_total>1350000.00</salario_total>
                        <fecha_contrato>1988-03-15</fecha_contrato>
                        <agente>Agenzia Artisti Italiani</agente>
                    </informacion_financiera>
                    <especialidad>Actor infantil y juvenil</especialidad>
                    <años_experiencia>15</años_experiencia>
                    <tipos_actuacion>
                        <tipo>Protagonista</tipo>
                    </tipos_actuacion>
                </actor>
                <tipo_actuacion>Protagonista</tipo_actuacion>
                <personaje>Salvatore (niño)</personaje>
                <fecha_inicio_rodaje>1988-05-01</fecha_inicio_rodaje>
                <fecha_fin_rodaje>1988-08-30</fecha_fin_rodaje>
                <notas>Debut cinematográfico extraordinario</notas>
            </participacion>
            
            <participacion>
                <actor>
                    <informacion_personal id="9">
                        <nombre>Philippe Noiret</nombre>
                        <fecha_nacimiento>1930-10-01</fecha_nacimiento>
                        <lugar_nacimiento>Lille, Francia</lugar_nacimiento>
                        <estado_civil>Casado</estado_civil>
                        <contacto>
                            <telefono>+33-01-444555</telefono>
                            <email>pnoiret@email.com</email>
                            <direccion>8 Boulevard Saint-Germain</direccion>
                            <ciudad>París</ciudad>
                            <pais>Francia</pais>
                        </contacto>
                        <biografia>Actor francés icónico del cine europeo, conocido por su versatilidad.</biografia>
                    </informacion_personal>
                    <informacion_financiera>
                        <salario_base>3200000.00</salario_base>
                        <bonificaciones>400000.00</bonificaciones>
                        <salario_total>3600000.00</salario_total>
                        <fecha_contrato>1988-02-20</fecha_contrato>
                        <agente>Agence Françoise Marquet</agente>
                    </informacion_financiera>
                    <especialidad>Actor de carácter</especialidad>
                    <años_experiencia>50</años_experiencia>
                    <tipos_actuacion>
                        <tipo>Protagonista</tipo>
                    </tipos_actuacion>
                </actor>
                <tipo_actuacion>Protagonista</tipo_actuacion>
                <personaje>Alfredo</personaje>
                <fecha_inicio_rodaje>1988-05-01</fecha_inicio_rodaje>
                <fecha_fin_rodaje>1988-08-30</fecha_fin_rodaje>
                <notas>Papel central e icónico de la película</notas>
            </participacion>
        </reparto>
        
        <produccion>
            <productor>
                <informacion_personal id="16">
                    <nombre>Franco Cristaldi</nombre>
                    <fecha_nacimiento>1924-10-03</fecha_nacimiento>
                    <lugar_nacimiento>Turín, Italia</lugar_nacimiento>
                    <estado_civil>Casado</estado_civil>
                    <contacto>
                        <telefono>+39-06-111222</telefono>
                        <email>fcristaldi@email.com</email>
                        <direccion>Via del Corso 100</direccion>
                        <ciudad>Roma</ciudad>
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Productor cinematográfico italiano, fundador de Vides Cinematografica.</biografia>
                </informacion_personal>
                <informacion_produccion>
                    <aportacion>8500000.00</aportacion>
                    <porcentaje_participacion>65.00</porcentaje_participacion>
                    <tipo_inversion>Inversión directa</tipo_inversion>
                    <empresa>Vides Cinematografica</empresa>
                </informacion_produccion>
                <empresa_productora>Vides Cinematografica</empresa_productora>
                <tipo_productor>Ejecutivo</tipo_productor>
                <proyectos_activos>3</proyectos_activos>
            </productor>
            <presupuesto>5000000.00</presupuesto>
            <recaudacion>12000000.00</recaudacion>
        </produccion>
        
        <criticas total="3">
            <critica fecha="1990-08-20" id="1">
                <autor>Mario Sesti</autor>
                <medio>La Gazzetta dello Sport</medio>
                <contenido>Una obra maestra del cine italiano que captura la esencia de la nostalgia con una maestría técnica excepcional. Tornatore logra crear una sinfonía visual que conecta emocionalmente con el espectador.</contenido>
                <puntuacion>4.8</puntuacion>
                <sentimiento>Muy Positivo</sentimiento>
            </critica>
            
            <critica fecha="1990-08-25" id="2">
                <autor>Lietta Tornabuoni</autor>
                <medio>Corriere della Sera</medio>
                <contenido>Tornatore crea una sinfonía visual de emociones y recuerdos que trasciende las barreras del tiempo. Una película que celebra el poder transformador del cine.</contenido>
                <puntuacion>4.7</puntuacion>
                <sentimiento>Positivo</sentimiento>
            </critica>
            
            <critica fecha="1990-08-28" id="3">
                <autor>Tullio Kezich</autor>
                <medio>La Repubblica</medio>
                <contenido>Un homenaje al poder del cine y a la memoria colectiva. Una obra que permanecerá en la historia del séptimo arte como referente indiscutible.</contenido>
                <puntuacion>4.9</puntuacion>
                <sentimiento>Muy Positivo</sentimiento>
            </critica>
        </criticas>
        
        <premios total="3">
            <premio id="1" tipo_certamen="Internacional">
                <nombre>Palma de Oro</nombre>
                <certamen>Festival de Cannes</certamen>
                <categoria>Mejor Película</categoria>
                <fecha_otorgamiento>1989-05-23</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
                <descripcion>Premio principal del Festival de Cannes, considerado uno de los más prestigiosos del mundo.</descripcion>
            </premio>
            
            <premio id="2" tipo_certamen="Internacional">
                <nombre>Oscar a Mejor Película Extranjera</nombre>
                <certamen>Academia de Hollywood</certamen>
                <categoria>Película Extranjera</categoria>
                <fecha_otorgamiento>1990-03-30</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
                <descripcion>Reconocimiento de la Academia de Artes y Ciencias Cinematográficas de Hollywood.</descripcion>
            </premio>
            
            <premio id="3" tipo_certamen="Nacional">
                <nombre>David di Donatello</nombre>
                <certamen>Academia del Cine Italiano</certamen>
                <categoria>Mejor Película</categoria>
                <fecha_otorgamiento>1989-07-15</fecha_otorgamiento>
                <prestigio>Alto</prestigio>
                <descripcion>Premio más importante del cine italiano, equivalente al Oscar.</descripcion>
            </premio>
        </premios>
        
        <metadatos>
            <fecha_creacion>2025-01-01T10:00:00</fecha_creacion>
            <version>1.0</version>
            <autor_documento>Sistema BDA ESCOM</autor_documento>
            <fuente>Base de datos cinematográfica ESCOM</fuente>
        </metadatos>
    </pelicula>')
);

-- Insertar La Dolce Vita como documento XML
INSERT INTO xml_cine.peliculas_xml (titulo, documento_xml) VALUES (
    'La Dolce Vita',
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <pelicula xmlns="http://escom.ipn.mx/cine" id="2" version_schema="1.0">
        <informacion_basica>
            <titulo>La Dolce Vita</titulo>
            <resumen>Marcello Mastroianni interpreta a un periodista romano que vive una vida hedonista en la alta sociedad de Roma, buscando historias escandalosas mientras navega por relaciones superficiales y encuentros vacíos. La película retrata la decadencia moral de la sociedad italiana de la época, explorando temas de alienación, búsqueda de significado y la corrupción del alma humana. A través de episodios interconectados, Fellini construye un fresco social que critica el materialismo y la pérdida de valores espirituales en la modernidad, utilizando imágenes surrealistas y simbólicas que han marcado la historia del cine mundial, convirtiéndose en un referente cultural que trasciende las fronteras del séptimo arte para influir en la literatura, la filosofía y el arte contemporáneo de manera profunda y duradera.</resumen>
            <fecha_estreno>1960-02-05</fecha_estreno>
            <ranking>4.7</ranking>
            <duracion_minutos>174</duracion_minutos>
            <idioma_original>Italiano</idioma_original>
            <pais_origen>Italia</pais_origen>
        </informacion_basica>
        
        <clasificacion>
            <genero>Drama</genero>
            <genero>Surrealista</genero>
            <genero>Social</genero>
        </clasificacion>
        
        <direccion>
            <director>
                <informacion_personal id="2">
                    <nombre>Federico Fellini</nombre>
                    <fecha_nacimiento>1920-01-20</fecha_nacimiento>
                    <lugar_nacimiento>Rimini, Italia</lugar_nacimiento>
                    <estado_civil>Casado</estado_civil>
                    <contacto>
                        <telefono>+39-06-234567</telefono>
                        <email>ffellini@email.com</email>
                        <direccion>Via Veneto 456</direccion>
                        <ciudad>Roma</ciudad>
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Uno de los directores más influyentes del cine italiano, conocido por su estilo surrealista y personal.</biografia>
                </informacion_personal>
                <estilo_direccion>Surrealismo cinematográfico</estilo_direccion>
                <escuela_cine>Autodicacta</escuela_cine>
                <años_experiencia>40</años_experiencia>
                <premios_direccion>
                    <premio>Palma de Oro - Cannes</premio>
                    <premio>Oscar Honorífico</premio>
                    <premio>León de Oro - Venecia</premio>
                </premios_direccion>
            </director>
        </direccion>
        
        <reparto>
            <participacion>
                <actor>
                    <informacion_personal id="21">
                        <nombre>Marcello Mastroianni</nombre>
                        <fecha_nacimiento>1924-09-28</fecha_nacimiento>
                        <lugar_nacimiento>Fontana Liri, Italia</lugar_nacimiento>
                        <estado_civil>Casado</estado_civil>
                        <contacto>
                            <telefono>+39-06-987654</telefono>
                            <email>mmastroianni@email.com</email>
                            <direccion>Via del Corso 500</direccion>
                            <ciudad>Roma</ciudad>
                            <pais>Italia</pais>
                        </contacto>
                        <biografia>Actor italiano icónico, símbolo del cine de autor europeo.</biografia>
                    </informacion_personal>
                    <informacion_financiera>
                        <salario_base>2800000.00</salario_base>
                        <bonificaciones>350000.00</bonificaciones>
                        <salario_total>3150000.00</salario_total>
                        <fecha_contrato>1959-10-15</fecha_contrato>
                        <agente>Agenzia Cinematografica Italiana</agente>
                    </informacion_financiera>
                    <especialidad>Actor de autor</especialidad>
                    <años_experiencia>35</años_experiencia>
                    <tipos_actuacion>
                        <tipo>Protagonista</tipo>
                    </tipos_actuacion>
                </actor>
                <tipo_actuacion>Protagonista</tipo_actuacion>
                <personaje>Marcello Rubini</personaje>
                <fecha_inicio_rodaje>1959-11-01</fecha_inicio_rodaje>
                <fecha_fin_rodaje>1960-01-30</fecha_fin_rodaje>
                <notas>Interpretación icónica que lo consagró como actor</notas>
            </participacion>
        </reparto>
        
        <produccion>
            <productor>
                <informacion_personal id="18">
                    <nombre>Dino De Laurentiis</nombre>
                    <fecha_nacimiento>1919-08-08</fecha_nacimiento>
                    <lugar_nacimiento>Torre Annunziata, Italia</lugar_nacimiento>
                    <estado_civil>Casado</estado_civil>
                    <contacto>
                        <telefono>+39-06-333444</telefono>
                        <email>ddelaurentiis@email.com</email>
                        <direccion>Via Appia 300</direccion>
                        <ciudad>Roma</ciudad>
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Productor cinematográfico italiano, uno de los más exitosos de la historia del cine.</biografia>
                </informacion_personal>
                <informacion_produccion>
                    <aportacion>15000000.00</aportacion>
                    <porcentaje_participacion>80.00</porcentaje_participacion>
                    <tipo_inversion>Inversión directa</tipo_inversion>
                    <empresa>De Laurentiis Entertainment Group</empresa>
                </informacion_produccion>
                <empresa_productora>De Laurentiis Entertainment Group</empresa_productora>
                <tipo_productor>Ejecutivo</tipo_productor>
                <proyectos_activos>5</proyectos_activos>
            </productor>
            <presupuesto>8000000.00</presupuesto>
            <recaudacion>25000000.00</recaudacion>
        </produccion>
        
        <criticas total="2">
            <critica fecha="1960-03-15" id="4">
                <autor>André Bazin</autor>
                <medio>Cahiers du Cinéma</medio>
                <contenido>Fellini reinventa el lenguaje cinematográfico con esta obra magistral que combina realismo y surrealismo de manera única en la historia del cine.</contenido>
                <puntuacion>4.9</puntuacion>
                <sentimiento>Muy Positivo</sentimiento>
            </critica>
            
            <critica fecha="1961-01-10" id="5">
                <autor>Pauline Kael</autor>
                <medio>The New Yorker</medio>
                <contenido>Una exploración fascinante de la sociedad moderna y sus contradicciones, presentada con una maestría visual incomparable.</contenido>
                <puntuacion>4.6</puntuacion>
                <sentimiento>Positivo</sentimiento>
            </critica>
        </criticas>
        
        <premios total="1">
            <premio id="4" tipo_certamen="Internacional">
                <nombre>Palma de Oro</nombre>
                <certamen>Festival de Cannes</certamen>
                <categoria>Mejor Película</categoria>
                <fecha_otorgamiento>1960-05-20</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
                <descripcion>Reconocimiento por su innovación cinematográfica y relevancia cultural.</descripcion>
            </premio>
        </premios>
        
        <metadatos>
            <fecha_creacion>2025-01-01T10:30:00</fecha_creacion>
            <version>1.0</version>
            <autor_documento>Sistema BDA ESCOM</autor_documento>
            <fuente>Base de datos cinematográfica ESCOM</fuente>
        </metadatos>
    </pelicula>')
);

-- Insertar personas como documentos XML separados
INSERT INTO xml_cine.personas_xml (nombre, tipo_persona, documento_xml) VALUES 
(
    'Giuseppe Tornatore',
    'Director',
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <persona xmlns="http://escom.ipn.mx/cine" tipo="Director">
        <director>
            <informacion_personal id="1">
                <nombre>Giuseppe Tornatore</nombre>
                <fecha_nacimiento>1956-05-27</fecha_nacimiento>
                <lugar_nacimiento>Bagheria, Sicilia, Italia</lugar_nacimiento>
                <estado_civil>Casado</estado_civil>
                <contacto>
                    <telefono>+39-091-123456</telefono>
                    <email>gtornatore@email.com</email>
                    <direccion>Via Roma 123, Bagheria</direccion>
                    <ciudad>Bagheria</ciudad>
                    <pais>Italia</pais>
                </contacto>
                <biografia>Cineasta italiano conocido por sus obras nostálgicas y poéticas que exploran temas de memoria, tiempo y cine.</biografia>
            </informacion_personal>
            <estilo_direccion>Realismo poético con elementos nostálgicos</estilo_direccion>
            <escuela_cine>Centro Sperimentale di Cinematografia</escuela_cine>
            <años_experiencia>35</años_experiencia>
            <premios_direccion>
                <premio>Palma de Oro - Cannes</premio>
                <premio>Oscar Mejor Película Extranjera</premio>
            </premios_direccion>
            <filmografia>
                <pelicula>
                    <titulo>Cinema Paradiso</titulo>
                    <año>1988</año>
                    <rol>Director</rol>
                </pelicula>
                <pelicula>
                    <titulo>Malèna</titulo>
                    <año>2000</año>
                    <rol>Director</rol>
                </pelicula>
            </filmografia>
        </director>
    </persona>')
),
(
    'Philippe Noiret',
    'Actor',
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <persona xmlns="http://escom.ipn.mx/cine" tipo="Actor">
        <actor>
            <informacion_personal id="9">
                <nombre>Philippe Noiret</nombre>
                <fecha_nacimiento>1930-10-01</fecha_nacimiento>
                <lugar_nacimiento>Lille, Francia</lugar_nacimiento>
                <estado_civil>Casado</estado_civil>
                <contacto>
                    <telefono>+33-01-444555</telefono>
                    <email>pnoiret@email.com</email>
                    <direccion>8 Boulevard Saint-Germain</direccion>
                    <ciudad>París</ciudad>
                    <pais>Francia</pais>
                </contacto>
                <biografia>Actor francés icónico del cine europeo, conocido por su versatilidad.</biografia>
            </informacion_personal>
            <informacion_financiera>
                <salario_base>3200000.00</salario_base>
                <bonificaciones>400000.00</bonificaciones>
                <salario_total>3600000.00</salario_total>
            </informacion_financiera>
            <especialidad>Actor de carácter</especialidad>
            <años_experiencia>50</años_experiencia>
            <tipos_actuacion>
                <tipo>Protagonista</tipo>
            </tipos_actuacion>
            <filmografia>
                <pelicula>
                    <titulo>Cinema Paradiso</titulo>
                    <año>1988</año>
                    <personaje>Alfredo</personaje>
                    <tipo_actuacion>Protagonista</tipo_actuacion>
                    <salario>3600000.00</salario>
                </pelicula>
            </filmografia>
        </actor>
    </persona>')
),
(
    'Franco Cristaldi',
    'Productor',
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <persona xmlns="http://escom.ipn.mx/cine" tipo="Productor">
        <productor>
            <informacion_personal id="16">
                <nombre>Franco Cristaldi</nombre>
                <fecha_nacimiento>1924-10-03</fecha_nacimiento>
                <lugar_nacimiento>Turín, Italia</lugar_nacimiento>
                <estado_civil>Casado</estado_civil>
                <contacto>
                    <telefono>+39-06-111222</telefono>
                    <email>fcristaldi@email.com</email>
                    <direccion>Via del Corso 100</direccion>
                    <ciudad>Roma</ciudad>
                    <pais>Italia</pais>
                </contacto>
                <biografia>Productor cinematográfico italiano, fundador de Vides Cinematografica.</biografia>
            </informacion_personal>
            <informacion_produccion>
                <aportacion>8500000.00</aportacion>
                <porcentaje_participacion>65.00</porcentaje_participacion>
                <tipo_inversion>Inversión directa</tipo_inversion>
                <empresa>Vides Cinematografica</empresa>
            </informacion_produccion>
            <empresa_productora>Vides Cinematografica</empresa_productora>
            <tipo_productor>Ejecutivo</tipo_productor>
            <proyectos_activos>3</proyectos_activos>
            <filmografia>
                <pelicula>
                    <titulo>Cinema Paradiso</titulo>
                    <año>1988</año>
                    <aportacion>8500000.00</aportacion>
                    <porcentaje>65.00</porcentaje>
                </pelicula>
            </filmografia>
        </productor>
    </persona>')
);

-- Insertar críticas como documento XML separado
INSERT INTO xml_cine.criticas_xml (id_pelicula, documento_xml) VALUES 
(
    1,
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <criticas xmlns="http://escom.ipn.mx/cine" pelicula_id="1">
        <pelicula_referencia>Cinema Paradiso</pelicula_referencia>
        
        <critica fecha="1990-08-20" id="1">
            <autor>Mario Sesti</autor>
            <medio>La Gazzetta dello Sport</medio>
            <contenido>Una obra maestra del cine italiano que captura la esencia de la nostalgia con una maestría técnica excepcional. Tornatore logra crear una sinfonía visual que conecta emocionalmente con el espectador, transportándolo a través del tiempo y el espacio hacia un mundo de recuerdos y emociones que parecen universales. La película trasciende las barreras culturales para convertirse en un testimonio del poder transformador del séptimo arte.</contenido>
            <puntuacion>4.8</puntuacion>
            <sentimiento>Muy Positivo</sentimiento>
        </critica>
        
        <critica fecha="1990-08-25" id="2">
            <autor>Lietta Tornabuoni</autor>
            <medio>Corriere della Sera</medio>
            <contenido>Tornatore crea una sinfonía visual de emociones y recuerdos que trasciende las barreras del tiempo. Una película que celebra el poder transformador del cine mientras narra una historia profundamente humana sobre la amistad, el amor y la pérdida. Cada fotograma está cargado de significado y belleza visual que permanece en la memoria del espectador mucho después de terminar la proyección.</contenido>
            <puntuacion>4.7</puntuacion>
            <sentimiento>Positivo</sentimiento>
        </critica>
        
        <critica fecha="1990-08-28" id="3">
            <autor>Tullio Kezich</autor>
            <medio>La República</medio>
            <contenido>Un homenaje al poder del cine y a la memoria colectiva. Una obra que permanecerá en la historia del séptimo arte como referente indiscutible de la capacidad del cine para conmover, enseñar y transformar. Tornatore demuestra que el cine puede ser tanto entretenimiento como arte sublime, creando una experiencia cinematográfica que trasciende generaciones y fronteras culturales.</contenido>
            <puntuacion>4.9</puntuacion>
            <sentimiento>Muy Positivo</sentimiento>
        </critica>
    </criticas>')
);

-- Insertar más películas con estructura XML simplificada
INSERT INTO xml_cine.peliculas_xml (titulo, documento_xml) VALUES 
(
    'La Vita è Bella',
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <pelicula xmlns="http://escom.ipn.mx/cine" id="3" version_schema="1.0">
        <informacion_basica>
            <titulo>La Vita è Bella</titulo>
            <resumen>Durante la Segunda Guerra Mundial, un padre judío usa su imaginación y humor para proteger a su hijo de los horrores del Holocausto, convirtiendo su experiencia en un campo de concentración en un juego elaborado. Roberto Benigni crea una obra maestra que combina comedia y drama de manera única, explorando temas de amor paternal, resistencia humana y el poder de la fantasía para superar las tragedias más profundas. La película demuestra cómo el amor puede transformar incluso las circunstancias más terribles, ofreciendo esperanza y dignidad en medio de la desesperación más absoluta, convirtiéndose en un himno a la vida y al espíritu humano indomable que trasciende las barreras culturales y lingüísticas para tocar los corazones de audiencias de todo el mundo con su mensaje universal de amor, sacrificio y esperanza que permanece relevante a través del tiempo.</resumen>
            <fecha_estreno>1997-12-20</fecha_estreno>
            <ranking>4.6</ranking>
            <duracion_minutos>116</duracion_minutos>
            <idioma_original>Italiano</idioma_original>
            <pais_origen>Italia</pais_origen>
        </informacion_basica>
        
        <clasificacion>
            <genero>Drama</genero>
            <genero>Comedia dramática</genero>
            <genero>Guerra</genero>
        </clasificacion>
        
        <direccion>
            <director>
                <informacion_personal id="3">
                    <nombre>Roberto Benigni</nombre>
                    <fecha_nacimiento>1952-10-27</fecha_nacimiento>
                    <lugar_nacimiento>Manciano La Misericordia, Italia</lugar_nacimiento>
                    <estado_civil>Casado</estado_civil>
                    <contacto>
                        <telefono>+39-055-345678</telefono>
                        <email>rbenigni@email.com</email>
                        <direccion>Piazza Signoria 789</direccion>
                        <ciudad>Firenze</ciudad>
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Actor, director y guionista italiano conocido por combinar comedia y drama en sus obras.</biografia>
                </informacion_personal>
                <estilo_direccion>Comedia dramática humanista</estilo_direccion>
                <escuela_cine>Teatro experimental</escuela_cine>
                <años_experiencia>30</años_experiencia>
                <premios_direccion>
                    <premio>Oscar Mejor Actor</premio>
                    <premio>Oscar Mejor Película Extranjera</premio>
                </premios_direccion>
            </director>
        </direccion>
        
        <reparto>
            <participacion>
                <actor>
                    <informacion_personal id="30">
                        <nombre>Roberto Benigni</nombre>
                        <fecha_nacimiento>1952-10-27</fecha_nacimiento>
                        <lugar_nacimiento>Manciano La Misericordia, Italia</lugar_nacimiento>
                        <estado_civil>Casado</estado_civil>
                        <contacto>
                            <telefono>+39-055-345678</telefono>
                            <email>rbenigni@email.com</email>
                            <direccion>Piazza Signoria 789</direccion>
                            <ciudad>Firenze</ciudad>
                            <pais>Italia</pais>
                        </contacto>
                    </informacion_personal>
                    <informacion_financiera>
                        <salario_base>4000000.00</salario_base>
                        <bonificaciones>500000.00</bonificaciones>
                        <salario_total>4500000.00</salario_total>
                    </informacion_financiera>
                    <especialidad>Actor cómico-dramático</especialidad>
                    <años_experiencia>30</años_experiencia>
                    <tipos_actuacion>
                        <tipo>Protagonista</tipo>
                    </tipos_actuacion>
                </actor>
                <tipo_actuacion>Protagonista</tipo_actuacion>
                <personaje>Guido Orefice</personaje>
                <notas>Interpretación magistral que le valió el Oscar</notas>
            </participacion>
        </reparto>
        
        <produccion>
            <presupuesto>20000000.00</presupuesto>
            <recaudacion>230000000.00</recaudacion>
        </produccion>
        
        <premios total="2">
            <premio id="5" tipo_certamen="Internacional">
                <nombre>Oscar a Mejor Actor</nombre>
                <certamen>Academia de Hollywood</certamen>
                <categoria>Mejor Actor</categoria>
                <fecha_otorgamiento>1999-03-21</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
            </premio>
            
            <premio id="6" tipo_certamen="Internacional">
                <nombre>Oscar a Mejor Película Extranjera</nombre>
                <certamen>Academia de Hollywood</certamen>
                <categoria>Película Extranjera</categoria>
                <fecha_otorgamiento>1999-03-21</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
            </premio>
        </premios>
        
        <metadatos>
            <fecha_creacion>2025-01-01T11:00:00</fecha_creacion>
            <version>1.0</version>
            <autor_documento>Sistema BDA ESCOM</autor_documento>
            <fuente>Base de datos cinematográfica ESCOM</fuente>
        </metadatos>
    </pelicula>')
);
