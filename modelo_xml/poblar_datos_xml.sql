-- POBLACION DE DATOS XML PARA MODELO SEMIESTRUCTURADO
-- Insercion de documentos XML validos segun el esquema XSD

-- Insertar Cinema Paradiso como documento XML completo
INSERT INTO xml_cine.peliculas_xml (titulo, documento_xml) VALUES (
    'Cinema Paradiso',
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <pelicula xmlns="http://escom.ipn.mx/cine" id="1" version_schema="1.0">
        <informacion_basica>
            <titulo>Cinema Paradiso</titulo>
            <resumen>Un hombre maduro recuerda su infancia en un pequeno pueblo siciliano donde desarrollo una amistad especial con el proyeccionista del cine local.</resumen>
            <fecha_estreno>1988-11-17</fecha_estreno>
            <ranking>4.8</ranking>
            <duracion_minutos>155</duracion_minutos>
            <idioma_original>Italiano</idioma_original>
            <pais_origen>Italia</pais_origen>
        </informacion_basica>
        
        <clasificacion>
            <genero>Drama</genero>
            <genero>Romance</genero>
            <genero>Nostalgico</genero>
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
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Cineasta italiano conocido por sus obras nostalgicas y poeticas.</biografia>
                </informacion_personal>
                <estilo_direccion>Realismo poetico con elementos nostalgicos</estilo_direccion>
                <escuela_cine>Centro Sperimentale di Cinematografia</escuela_cine>
                <anos_experiencia>35</anos_experiencia>
                <premios_direccion>
                    <premio>Palma de Oro - Cannes</premio>
                    <premio>Oscar Mejor Pelicula Extranjera</premio>
                </premios_direccion>
            </director>
        </direccion>
        
        <reparto>
            <participacion>
                <actor>
                    <informacion_personal id="6">
                        <nombre>Salvatore Cascio</nombre>
                        <biografia>Actor italiano que debuto como nino en Cinema Paradiso.</biografia>
                    </informacion_personal>
                    <informacion_financiera>
                        <salario_base>1200000.00</salario_base>
                        <agente>Agenzia Artisti Italiani</agente>
                    </informacion_financiera>
                    <especialidad>Actor infantil y juvenil</especialidad>
                    <anos_experiencia>15</anos_experiencia>
                    <tipos_actuacion>
                        <tipo>Protagonista</tipo>
                    </tipos_actuacion>
                </actor>
                <tipo_actuacion>Protagonista</tipo_actuacion>
                <personaje>Salvatore (nino)</personaje>
                <fecha_inicio_rodaje>1988-05-01</fecha_inicio_rodaje>
                <fecha_fin_rodaje>1988-08-30</fecha_fin_rodaje>
                <notas>Debut cinematografico extraordinario</notas>
            </participacion>
            
            <participacion>
                <actor>
                    <informacion_personal id="9">
                        <nombre>Philippe Noiret</nombre>
                        <biografia>Actor frances iconico del cine europeo, conocido por su versatilidad.</biografia>
                    </informacion_personal>
                    <informacion_financiera>
                        <salario_base>3200000.00</salario_base>
                        <agente>Agence Francoise Marquet</agente>
                    </informacion_financiera>
                    <especialidad>Actor de caracter</especialidad>
                    <anos_experiencia>50</anos_experiencia>
                    <tipos_actuacion>
                        <tipo>Protagonista</tipo>
                    </tipos_actuacion>
                </actor>
                <tipo_actuacion>Protagonista</tipo_actuacion>
                <personaje>Alfredo</personaje>
                <fecha_inicio_rodaje>1988-05-01</fecha_inicio_rodaje>
                <fecha_fin_rodaje>1988-08-30</fecha_fin_rodaje>
                <notas>Papel central e iconico de la pelicula</notas>
            </participacion>
        </reparto>
        
        <produccion>
            <productor>
                <informacion_personal id="16">
                    <nombre>Franco Cristaldi</nombre>
                    <fecha_nacimiento>1924-10-03</fecha_nacimiento>
                    <lugar_nacimiento>Turin, Italia</lugar_nacimiento>
                    <estado_civil>Casado</estado_civil>
                    <contacto>
                        <telefono>+39-06-111222</telefono>
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Productor cinematografico italiano, fundador de Vides Cinematografica.</biografia>
                </informacion_personal>
                <informacion_produccion>
                    <aportacion>8500000.00</aportacion>
                    <porcentaje_participacion>65.00</porcentaje_participacion>
                    <tipo_inversion>Inversion directa</tipo_inversion>
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
                <contenido>Una obra maestra del cine italiano que captura la esencia de la nostalgia con una maestria tecnica excepcional.</contenido>
                <puntuacion>4.8</puntuacion>
                <sentimiento>Muy Positivo</sentimiento>
            </critica>
            
            <critica fecha="1990-08-25" id="2">
                <autor>Lietta Tornabuoni</autor>
                <medio>Corriere della Sera</medio>
                <contenido>Tornatore crea una sinfonia visual de emociones y recuerdos que trasciende las barreras del tiempo.</contenido>
                <puntuacion>4.7</puntuacion>
                <sentimiento>Positivo</sentimiento>
            </critica>
            
            <critica fecha="1990-08-28" id="3">
                <autor>Tullio Kezich</autor>
                <medio>La Republica</medio>
                <contenido>Un homenaje al poder del cine y a la memoria colectiva. Una obra que permanecera en la historia del septimo arte.</contenido>
                <puntuacion>4.9</puntuacion>
                <sentimiento>Muy Positivo</sentimiento>
            </critica>
        </criticas>
        
        <premios total="3">
            <premio id="1" tipo_certamen="Internacional">
                <nombre>Palma de Oro</nombre>
                <certamen>Festival de Cannes</certamen>
                <categoria>Mejor Pelicula</categoria>
                <fecha_otorgamiento>1989-05-23</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
                <descripcion>Premio principal del Festival de Cannes, considerado uno de los mas prestigiosos del mundo.</descripcion>
            </premio>
            
            <premio id="2" tipo_certamen="Internacional">
                <nombre>Oscar a Mejor Pelicula Extranjera</nombre>
                <certamen>Academia de Hollywood</certamen>
                <categoria>Pelicula Extranjera</categoria>
                <fecha_otorgamiento>1990-03-30</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
                <descripcion>Reconocimiento de la Academia de Artes y Ciencias Cinematograficas de Hollywood.</descripcion>
            </premio>
            
            <premio id="3" tipo_certamen="Nacional">
                <nombre>David di Donatello</nombre>
                <certamen>Academia del Cine Italiano</certamen>
                <categoria>Mejor Pelicula</categoria>
                <fecha_otorgamiento>1989-07-15</fecha_otorgamiento>
                <prestigio>Alto</prestigio>
                <descripcion>Premio mas importante del cine italiano, equivalente al Oscar.</descripcion>
            </premio>
        </premios>
        
        <metadatos>
            <fecha_creacion>2025-01-01T10:00:00</fecha_creacion>
            <version>1.0</version>
            <autor_documento>Sistema BDA ESCOM</autor_documento>
            <fuente>Base de datos cinematografica ESCOM</fuente>
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
            <resumen>Marcello Mastroianni interpreta a un periodista romano que vive una vida hedonista en la alta sociedad de Roma.</resumen>
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
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Uno de los directores mas influyentes del cine italiano, conocido por su estilo surrealista y personal.</biografia>
                </informacion_personal>
                <estilo_direccion>Surrealismo cinematografico</estilo_direccion>
                <escuela_cine>Autodicacta</escuela_cine>
                <anos_experiencia>40</anos_experiencia>
                <premios_direccion>
                    <premio>Palma de Oro - Cannes</premio>
                    <premio>Oscar Honorif ico</premio>
                    <premio>Leon de Oro - Venecia</premio>
                </premios_direccion>
            </director>
        </direccion>
        
        <reparto>
            <participacion>
                <actor>
                    <informacion_personal id="21">
                        <nombre>Marcello Mastroianni</nombre>
                        <biografia>Actor italiano iconico, simbolo del cine de autor europeo.</biografia>
                    </informacion_personal>
                    <informacion_financiera>
                        <salario_base>2800000.00</salario_base>
                        <agente>Agenzia Cinematografica Italiana</agente>
                    </informacion_financiera>
                    <especialidad>Actor de autor</especialidad>
                    <anos_experiencia>35</anos_experiencia>
                    <tipos_actuacion>
                        <tipo>Protagonista</tipo>
                    </tipos_actuacion>
                </actor>
                <tipo_actuacion>Protagonista</tipo_actuacion>
                <personaje>Marcello Rubini</personaje>
                <fecha_inicio_rodaje>1959-11-01</fecha_inicio_rodaje>
                <fecha_fin_rodaje>1960-01-30</fecha_fin_rodaje>
                <notas>Interpretacion iconica que lo consagro como actor</notas>
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
                        <pais>Italia</pais>
                    </contacto>
                    <biografia>Productor cinematografico italiano, uno de los mas exitosos de la historia del cine.</biografia>
                </informacion_personal>
                <informacion_produccion>
                    <aportacion>15000000.00</aportacion>
                    <porcentaje_participacion>80.00</porcentaje_participacion>
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
                <autor>Andre Bazin</autor>
                <medio>Cahiers du Cinema</medio>
                <contenido>Fellini reinventa el lenguaje cinematografico con esta obra magistral que combina realismo y surrealismo.</contenido>
                <puntuacion>4.9</puntuacion>
                <sentimiento>Muy Positivo</sentimiento>
            </critica>
            
            <critica fecha="1961-01-10" id="5">
                <autor>Pauline Kael</autor>
                <medio>The New Yorker</medio>
                <contenido>Una exploracion fascinante de la sociedad moderna y sus contradicciones, presentada con una maestria visual incomparable.</contenido>
                <puntuacion>4.6</puntuacion>
                <sentimiento>Positivo</sentimiento>
            </critica>
        </criticas>
        
        <premios total="1">
            <premio id="4" tipo_certamen="Internacional">
                <nombre>Palma de Oro</nombre>
                <certamen>Festival de Cannes</certamen>
                <categoria>Mejor Pelicula</categoria>
                <fecha_otorgamiento>1960-05-20</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
                <descripcion>Reconocimiento por su innovacion cinematografica y relevancia cultural.</descripcion>
            </premio>
        </premios>
        
        <metadatos>
            <fecha_creacion>2025-01-01T10:30:00</fecha_creacion>
            <version>1.0</version>
            <autor_documento>Sistema BDA ESCOM</autor_documento>
            <fuente>Base de datos cinematografica ESCOM</fuente>
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
                    <pais>Italia</pais>
                </contacto>
                <biografia>Cineasta italiano conocido por sus obras nostalgicas y poeticas que exploran temas de memoria, tiempo y cine.</biografia>
            </informacion_personal>
            <estilo_direccion>Realismo poetico con elementos nostalgicos</estilo_direccion>
            <escuela_cine>Centro Sperimentale di Cinematografia</escuela_cine>
            <anos_experiencia>35</anos_experiencia>
            <premios_direccion>
                <premio>Palma de Oro - Cannes</premio>
                <premio>Oscar Mejor Pelicula Extranjera</premio>
            </premios_direccion>
            <filmografia>
                <pelicula>
                    <titulo>Cinema Paradiso</titulo>
                    <rol>Director</rol>
                </pelicula>
                <pelicula>
                    <titulo>Malena</titulo>
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
                    <pais>Francia</pais>
                </contacto>
                <biografia>Actor frances iconico del cine europeo, conocido por su versatilidad.</biografia>
            </informacion_personal>
            <informacion_financiera>
                <salario_base>3200000.00</salario_base>
                <bonificaciones>400000.00</bonificaciones>
                <salario_total>3600000.00</salario_total>
            </informacion_financiera>
            <especialidad>Actor de caracter</especialidad>
            <anos_experiencia>50</anos_experiencia>
            <tipos_actuacion>
                <tipo>Protagonista</tipo>
            </tipos_actuacion>
            <filmografia>
                <pelicula>
                    <titulo>Cinema Paradiso</titulo>
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
                <lugar_nacimiento>Turin, Italia</lugar_nacimiento>
                <estado_civil>Casado</estado_civil>
                <contacto>
                    <telefono>+39-06-111222</telefono>
                    <pais>Italia</pais>
                </contacto>
                <biografia>Productor cinematografico italiano, fundador de Vides Cinematografica.</biografia>
            </informacion_personal>
            <informacion_produccion>
                <aportacion>8500000.00</aportacion>
                <porcentaje_participacion>65.00</porcentaje_participacion>
                <tipo_inversion>Inversion directa</tipo_inversion>
                <empresa>Vides Cinematografica</empresa>
            </informacion_produccion>
            <empresa_productora>Vides Cinematografica</empresa_productora>
            <tipo_productor>Ejecutivo</tipo_productor>
            <proyectos_activos>3</proyectos_activos>
            <filmografia>
                <pelicula>
                    <titulo>Cinema Paradiso</titulo>
                    <porcentaje>65.00</porcentaje>
                </pelicula>
            </filmografia>
        </productor>
    </persona>')
);

-- Insertar criticas como documento XML separado
INSERT INTO xml_cine.criticas_xml (id_pelicula, documento_xml) VALUES 
(
    1,
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <criticas xmlns="http://escom.ipn.mx/cine" pelicula_id="1">
        <pelicula_referencia>Cinema Paradiso</pelicula_referencia>
        
        <critica fecha="1990-08-20" id="1">
            <autor>Mario Sesti</autor>
            <medio>La Gazzetta dello Sport</medio>
            <contenido>Una obra maestra del cine italiano que captura la esencia de la nostalgia con una maestria tecnica excepcional.</contenido>
            <puntuacion>4.8</puntuacion>
            <sentimiento>Muy Positivo</sentimiento>
        </critica>
        
        <critica fecha="1990-08-25" id="2">
            <autor>Lietta Tornabuoni</autor>
            <medio>Corriere della Sera</medio>
            <contenido>Tornatore crea una sinfonia visual de emociones y recuerdos que trasciende las barreras del tiempo.</contenido>
            <puntuacion>4.7</puntuacion>
            <sentimiento>Positivo</sentimiento>
        </critica>
        
        <critica fecha="1990-08-28" id="3">
            <autor>Tullio Kezich</autor>
            <medio>La Republica</medio>
            <contenido>Un homenaje al poder del cine y a la memoria colectiva. Una obra que permanecera en la historia del septimo arte.</contenido>
            <puntuacion>4.9</puntuacion>
            <sentimiento>Muy Positivo</sentimiento>
        </critica>
    </criticas>')
);

-- Insertar mas peliculas con estructura XML simplificada
INSERT INTO xml_cine.peliculas_xml (titulo, documento_xml) VALUES 
(
    'La Vita e Bella',
    XMLPARSE(DOCUMENT '<?xml version="1.0" encoding="UTF-8"?>
    <pelicula xmlns="http://escom.ipn.mx/cine" id="3" version_schema="1.0">
        <informacion_basica>
            <titulo>La Vita e Bella</titulo>
            <resumen>Durante la Segunda Guerra Mundial, un padre judio usa su imaginacion y humor para proteger a su hijo de los horrores del Holocausto.</resumen>
            <fecha_estreno>1997-12-20</fecha_estreno>
            <ranking>4.6</ranking>
            <duracion_minutos>116</duracion_minutos>
            <idioma_original>Italiano</idioma_original>
            <pais_origen>Italia</pais_origen>
        </informacion_basica>
        
        <clasificacion>
            <genero>Drama</genero>
            <genero>Comedia dramatica</genero>
            <genero>Guerra</genero>
        </clasificacion>
        
        <direccion>
            <director>
                <informacion_personal id="3">
                    <nombre>Roberto Benigni</nombre>
                    <biografia>Actor, director y guionista italiano conocido por combinar comedia y drama en sus obras.</biografia>
                </informacion_personal>
                <estilo_direccion>Comedia dramatica humanista</estilo_direccion>
                <escuela_cine>Teatro experimental</escuela_cine>
                <anos_experiencia>30</anos_experiencia>
                <premios_direccion>
                    <premio>Oscar Mejor Actor</premio>
                    <premio>Oscar Mejor Pelicula Extranjera</premio>
                </premios_direccion>
            </director>
        </direccion>
        
        <reparto>
            <participacion>
                <actor>
                    <informacion_personal id="30">
                        <nombre>Roberto Benigni</nombre>
                        <biografia>Actor y director italiano, conocido por su energia y carisma en pantalla.</biografia>
                    </informacion_personal>
                    <informacion_financiera>
                        <salario_base>5000000.00</salario_base>
                    </informacion_financiera>
                    <especialidad>Actor comico</especialidad>
                    <anos_experiencia>30</anos_experiencia>
                    <tipos_actuacion>
                        <tipo>Protagonista</tipo>
                    </tipos_actuacion>
                </actor>
                <tipo_actuacion>Protagonista</tipo_actuacion>
                <personaje>Guido Orefice</personaje>
                <notas>Interpretacion magistral que le valio el Oscar</notas>
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
                <nombre>Oscar a Mejor Pelicula Extranjera</nombre>
                <certamen>Academia de Hollywood</certamen>
                <categoria>Pelicula Extranjera</categoria>
                <fecha_otorgamiento>1999-03-21</fecha_otorgamiento>
                <prestigio>Muy Alto</prestigio>
            </premio>
        </premios>
        
        <metadatos>
            <fecha_creacion>2025-01-01T11:00:00</fecha_creacion>
            <version>1.0</version>
            <autor_documento>Sistema BDA ESCOM</autor_documento>
            <fuente>Base de datos cinematografica ESCOM</fuente>
        </metadatos>
    </pelicula>')
);
