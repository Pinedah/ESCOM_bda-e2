// MODELO SEMIESTRUCTURADO JSON - MONGODB
// Scripts de creación, población y consultas usando MongoDB Shell (BSON)

// ===== CONFIGURACIÓN Y CREACIÓN DE BASE DE DATOS =====

// Conectar y crear base de datos
use cine_db;

// ===== CREACIÓN DE COLECCIONES =====

// Crear colección de películas con validación de esquema
db.createCollection("peliculas", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["titulo", "resumen", "fecha_estreno", "ranking", "director", "reparto", "produccion"],
            properties: {
                titulo: {
                    bsonType: "string",
                    minLength: 1,
                    maxLength: 150,
                    description: "Título de la película requerido entre 1 y 150 caracteres"
                },
                resumen: {
                    bsonType: "string",
                    minLength: 1000,
                    maxLength: 3000,
                    description: "Resumen de película entre 250 y 450 palabras aproximadamente"
                },
                fecha_estreno: {
                    bsonType: "date",
                    description: "Fecha de estreno requerida"
                },
                ranking: {
                    bsonType: "double",
                    minimum: 1.0,
                    maximum: 5.0,
                    description: "Ranking entre 1.0 y 5.0"
                },
                director: {
                    bsonType: "object",
                    required: ["director_id", "nombre"],
                    properties: {
                        director_id: { bsonType: "objectId" },
                        nombre: { bsonType: "string" }
                    }
                },
                reparto: {
                    bsonType: "array",
                    minItems: 1,
                    items: {
                        bsonType: "object",
                        required: ["actor_id", "tipo_actuacion"],
                        properties: {
                            actor_id: { bsonType: "objectId" },
                            tipo_actuacion: {
                                bsonType: "string",
                                enum: ["Protagonista", "Secundario", "De reparto", "Extra"]
                            }
                        }
                    }
                },
                produccion: {
                    bsonType: "array",
                    minItems: 1,
                    items: {
                        bsonType: "object",
                        required: ["productor_id"],
                        properties: {
                            productor_id: { bsonType: "objectId" }
                        }
                    }
                }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error"
});

// Crear colección de personas (actores, directores, productores)
db.createCollection("personas", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["tipo_persona", "informacion_personal"],
            properties: {
                tipo_persona: {
                    bsonType: "string",
                    enum: ["Actor", "Director", "Productor"],
                    description: "Tipo de persona requerido"
                },
                informacion_personal: {
                    bsonType: "object",
                    required: ["nombre", "fecha_nacimiento", "estado_civil", "contacto"],
                    properties: {
                        nombre: {
                            bsonType: "string",
                            minLength: 2,
                            maxLength: 100
                        },
                        fecha_nacimiento: { bsonType: "date" },
                        estado_civil: {
                            bsonType: "string",
                            enum: ["Soltero", "Casado", "Divorciado", "Viudo", "Unión libre"]
                        },
                        contacto: {
                            bsonType: "object",
                            required: ["telefono", "pais"],
                            properties: {
                                telefono: { bsonType: "string" },
                                pais: { bsonType: "string" }
                            }
                        }
                    }
                }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error"
});

// Crear colección para críticas independientes
db.createCollection("criticas", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["pelicula_id", "autor", "medio", "fecha", "contenido"],
            properties: {
                pelicula_id: { bsonType: "objectId" },
                autor: { bsonType: "string" },
                medio: { bsonType: "string" },
                fecha: { bsonType: "date" },
                contenido: { bsonType: "string" },
                puntuacion: {
                    bsonType: "double",
                    minimum: 1.0,
                    maximum: 5.0
                }
            }
        }
    }
});

// Crear colección para premios independientes
db.createCollection("premios", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["pelicula_id", "nombre", "certamen", "fecha_otorgamiento"],
            properties: {
                pelicula_id: { bsonType: "objectId" },
                nombre: { bsonType: "string" },
                certamen: { bsonType: "string" },
                fecha_otorgamiento: { bsonType: "date" },
                tipo_certamen: {
                    bsonType: "string",
                    enum: ["Nacional", "Internacional"]
                }
            }
        }
    }
});

// ===== CREACIÓN DE ÍNDICES =====

// Índices para películas
db.peliculas.createIndex({ "titulo": "text", "resumen": "text" }, { 
    name: "idx_busqueda_texto",
    weights: { "titulo": 10, "resumen": 1 }
});
db.peliculas.createIndex({ "fecha_estreno": 1 }, { name: "idx_fecha_estreno" });
db.peliculas.createIndex({ "ranking": -1 }, { name: "idx_ranking_desc" });
db.peliculas.createIndex({ "director.nombre": 1 }, { name: "idx_director_nombre" });
db.peliculas.createIndex({ "generos": 1 }, { name: "idx_generos" });

// Índices para personas
db.personas.createIndex({ "tipo_persona": 1, "informacion_personal.nombre": 1 }, { name: "idx_tipo_nombre" });
db.personas.createIndex({ "informacion_personal.nombre": "text" }, { name: "idx_nombre_texto" });
db.personas.createIndex({ "informacion_personal.fecha_nacimiento": 1 }, { name: "idx_fecha_nacimiento" });

// Índices para críticas
db.criticas.createIndex({ "pelicula_id": 1, "fecha": -1 }, { name: "idx_pelicula_fecha" });
db.criticas.createIndex({ "medio": 1 }, { name: "idx_medio" });

// Índices para premios
db.premios.createIndex({ "pelicula_id": 1 }, { name: "idx_pelicula_premios" });
db.premios.createIndex({ "tipo_certamen": 1 }, { name: "idx_tipo_certamen" });

print("✅ Colecciones e índices creados exitosamente");

// ===== POBLACIÓN DE DATOS =====

// Insertar directores
var directores = [];

var tornatore_id = ObjectId();
directores.push({
    _id: tornatore_id,
    tipo_persona: "Director",
    informacion_personal: {
        nombre: "Giuseppe Tornatore",
        fecha_nacimiento: new Date("1956-05-27"),
        lugar_nacimiento: "Bagheria, Sicilia, Italia",
        estado_civil: "Casado",
        contacto: {
            telefono: "+39-091-123456",
            email: "gtornatore@email.com",
            direccion: "Via Roma 123",
            ciudad: "Bagheria",
            pais: "Italia"
        },
        biografia: "Cineasta italiano conocido por sus obras nostálgicas y poéticas que exploran temas de memoria, tiempo y cine."
    },
    estilo_direccion: "Realismo poético con elementos nostálgicos",
    escuela_cine: "Centro Sperimentale di Cinematografia",
    años_experiencia: 35,
    premios_direccion: [
        "Palma de Oro - Cannes",
        "Oscar Mejor Película Extranjera"
    ],
    peliculas_dirigidas: 0,
    filmografia: [
        {
            titulo: "Cinema Paradiso",
            año: 1988,
            rol: "Director"
        },
        {
            titulo: "Malèna",
            año: 2000,
            rol: "Director"
        }
    ]
});

var fellini_id = ObjectId();
directores.push({
    _id: fellini_id,
    tipo_persona: "Director",
    informacion_personal: {
        nombre: "Federico Fellini",
        fecha_nacimiento: new Date("1920-01-20"),
        lugar_nacimiento: "Rimini, Italia",
        estado_civil: "Casado",
        contacto: {
            telefono: "+39-06-234567",
            email: "ffellini@email.com",
            direccion: "Via Veneto 456",
            ciudad: "Roma",
            pais: "Italia"
        },
        biografia: "Uno de los directores más influyentes del cine italiano, conocido por su estilo surrealista y personal."
    },
    estilo_direccion: "Surrealismo cinematográfico",
    escuela_cine: "Autodicacta",
    años_experiencia: 40,
    premios_direccion: [
        "Palma de Oro - Cannes",
        "Oscar Honorífico",
        "León de Oro - Venecia"
    ],
    peliculas_dirigidas: 0
});

var benigni_id = ObjectId();
directores.push({
    _id: benigni_id,
    tipo_persona: "Director",
    informacion_personal: {
        nombre: "Roberto Benigni",
        fecha_nacimiento: new Date("1952-10-27"),
        lugar_nacimiento: "Manciano La Misericordia, Italia",
        estado_civil: "Casado",
        contacto: {
            telefono: "+39-055-345678",
            email: "rbenigni@email.com",
            direccion: "Piazza Signoria 789",
            ciudad: "Firenze",
            pais: "Italia"
        },
        biografia: "Actor, director y guionista italiano conocido por combinar comedia y drama en sus obras."
    },
    estilo_direccion: "Comedia dramática humanista",
    escuela_cine: "Teatro experimental",
    años_experiencia: 30,
    premios_direccion: [
        "Oscar Mejor Actor",
        "Oscar Mejor Película Extranjera"
    ],
    peliculas_dirigidas: 0
});

db.personas.insertMany(directores);
print("✅ Directores insertados: " + directores.length);

// Insertar actores
var actores = [];

var cascio_id = ObjectId();
actores.push({
    _id: cascio_id,
    tipo_persona: "Actor",
    informacion_personal: {
        nombre: "Salvatore Cascio",
        fecha_nacimiento: new Date("1979-11-08"),
        lugar_nacimiento: "Palazzo Adriano, Sicilia, Italia",
        estado_civil: "Casado",
        contacto: {
            telefono: "+39-090-111222",
            email: "scascio@email.com",
            direccion: "Via Garibaldi 10",
            ciudad: "Palazzo Adriano",
            pais: "Italia"
        },
        biografia: "Actor italiano que debutó como niño en Cinema Paradiso."
    },
    informacion_financiera: {
        salario_base: 1200000.00,
        bonificaciones: 150000.00,
        salario_total: 1350000.00,
        fecha_contrato: new Date("1988-03-15"),
        agente: "Agenzia Artisti Italiani"
    },
    especialidad: "Actor infantil y juvenil",
    años_experiencia: 15,
    tipos_actuacion: ["Protagonista"],
    filmografia: [
        {
            pelicula: "Cinema Paradiso",
            año: 1988,
            personaje: "Salvatore (niño)",
            tipo_actuacion: "Protagonista",
            salario: 1350000.00
        }
    ]
});

var leonardi_id = ObjectId();
actores.push({
    _id: leonardi_id,
    tipo_persona: "Actor",
    informacion_personal: {
        nombre: "Marco Leonardi",
        fecha_nacimiento: new Date("1971-11-14"),
        lugar_nacimiento: "Melbourne, Australia",
        estado_civil: "Divorciado",
        contacto: {
            telefono: "+39-06-222333",
            email: "mleonardi@email.com",
            direccion: "Via Trastevere 25",
            ciudad: "Roma",
            pais: "Italia"
        },
        biografia: "Actor italiano-australiano conocido por sus roles en Cinema Paradiso y otras producciones."
    },
    informacion_financiera: {
        salario_base: 1800000.00,
        bonificaciones: 200000.00,
        salario_total: 2000000.00,
        fecha_contrato: new Date("1988-03-20"),
        agente: "International Talent Agency"
    },
    especialidad: "Actor dramático",
    años_experiencia: 25,
    tipos_actuacion: ["Protagonista", "Secundario"],
    filmografia: [
        {
            pelicula: "Cinema Paradiso",
            año: 1988,
            personaje: "Salvatore (joven)",
            tipo_actuacion: "Protagonista",
            salario: 2000000.00
        }
    ]
});

var perrin_id = ObjectId();
actores.push({
    _id: perrin_id,
    tipo_persona: "Actor",
    informacion_personal: {
        nombre: "Jacques Perrin",
        fecha_nacimiento: new Date("1941-07-13"),
        lugar_nacimiento: "París, Francia",
        estado_civil: "Casado",
        contacto: {
            telefono: "+33-01-333444",
            email: "jperrin@email.com",
            direccion: "15 Rue de Rivoli",
            ciudad: "París",
            pais: "Francia"
        },
        biografia: "Actor y productor francés con una larga carrera en cine europeo."
    },
    informacion_financiera: {
        salario_base: 2500000.00,
        bonificaciones: 300000.00,
        salario_total: 2800000.00,
        fecha_contrato: new Date("1988-02-10"),
        agente: "Agence Françoise Marquet"
    },
    especialidad: "Actor veterano",
    años_experiencia: 45,
    tipos_actuacion: ["Protagonista", "Secundario"],
    filmografia: [
        {
            pelicula: "Cinema Paradiso",
            año: 1988,
            personaje: "Salvatore (adulto)",
            tipo_actuacion: "Protagonista",
            salario: 2800000.00
        }
    ]
});

var noiret_id = ObjectId();
actores.push({
    _id: noiret_id,
    tipo_persona: "Actor",
    informacion_personal: {
        nombre: "Philippe Noiret",
        fecha_nacimiento: new Date("1930-10-01"),
        lugar_nacimiento: "Lille, Francia",
        estado_civil: "Casado",
        contacto: {
            telefono: "+33-01-444555",
            email: "pnoiret@email.com",
            direccion: "8 Boulevard Saint-Germain",
            ciudad: "París",
            pais: "Francia"
        },
        biografia: "Actor francés icónico del cine europeo, conocido por su versatilidad."
    },
    informacion_financiera: {
        salario_base: 3200000.00,
        bonificaciones: 400000.00,
        salario_total: 3600000.00,
        fecha_contrato: new Date("1988-02-20"),
        agente: "Agence Françoise Marquet"
    },
    especialidad: "Actor de carácter",
    años_experiencia: 50,
    tipos_actuacion: ["Protagonista"],
    filmografia: [
        {
            pelicula: "Cinema Paradiso",
            año: 1988,
            personaje: "Alfredo",
            tipo_actuacion: "Protagonista",
            salario: 3600000.00
        }
    ]
});

// Agregar más actores para completar 100+
for (let i = 5; i <= 100; i++) {
    actores.push({
        _id: ObjectId(),
        tipo_persona: "Actor",
        informacion_personal: {
            nombre: `Actor Italiano ${i}`,
            fecha_nacimiento: new Date(1950 + (i % 40), (i % 12), (i % 28) + 1),
            lugar_nacimiento: "Italia",
            estado_civil: ["Soltero", "Casado", "Divorciado", "Viudo"][i % 4],
            contacto: {
                telefono: "+39-06-" + String(i).padStart(6, '0'),
                email: `actor${i}@email.com`,
                direccion: `Via Roma ${i}`,
                ciudad: "Roma",
                pais: "Italia"
            }
        },
        informacion_financiera: {
            salario_base: 600000 + (i * 50000),
            bonificaciones: 50000 + (i * 5000),
            salario_total: 650000 + (i * 55000)
        },
        especialidad: ["Actor dramático", "Actor cómico", "Actor de acción", "Actor de carácter"][i % 4],
        años_experiencia: 10 + (i % 30),
        tipos_actuacion: [["Protagonista"], ["Secundario"], ["De reparto"], ["Extra"]][i % 4]
    });
}

db.personas.insertMany(actores);
print("✅ Actores insertados: " + actores.length);

// Insertar productores
var productores = [];

var cristaldi_id = ObjectId();
productores.push({
    _id: cristaldi_id,
    tipo_persona: "Productor",
    informacion_personal: {
        nombre: "Franco Cristaldi",
        fecha_nacimiento: new Date("1924-10-03"),
        lugar_nacimiento: "Turín, Italia",
        estado_civil: "Casado",
        contacto: {
            telefono: "+39-06-111222",
            email: "fcristaldi@email.com",
            direccion: "Via del Corso 100",
            ciudad: "Roma",
            pais: "Italia"
        },
        biografia: "Productor cinematográfico italiano, fundador de Vides Cinematografica."
    },
    informacion_produccion: {
        aportacion: 8500000.00,
        porcentaje_participacion: 65.00,
        tipo_inversion: "Inversión directa",
        empresa: "Vides Cinematografica"
    },
    empresa_productora: "Vides Cinematografica",
    tipo_productor: "Ejecutivo",
    proyectos_activos: 3,
    filmografia: [
        {
            pelicula: "Cinema Paradiso",
            año: 1988,
            aportacion: 8500000.00,
            porcentaje: 65.00
        }
    ]
});

var romagnoli_id = ObjectId();
productores.push({
    _id: romagnoli_id,
    tipo_persona: "Productor",
    informacion_personal: {
        nombre: "Giovanna Romagnoli",
        fecha_nacimiento: new Date("1935-09-15"),
        lugar_nacimiento: "Roma, Italia",
        estado_civil: "Casada",
        contacto: {
            telefono: "+39-06-222333",
            email: "gromagnoli@email.com",
            direccion: "Via Nazionale 200",
            ciudad: "Roma",
            pais: "Italia"
        },
        biografia: "Productora asociada especializada en cine de autor italiano."
    },
    informacion_produccion: {
        aportacion: 3200000.00,
        porcentaje_participacion: 35.00,
        tipo_inversion: "Coproducción",
        empresa: "Romagnoli Films"
    },
    empresa_productora: "Romagnoli Films",
    tipo_productor: "Asociada",
    proyectos_activos: 2
});

// Agregar más productores
for (let i = 3; i <= 20; i++) {
    productores.push({
        _id: ObjectId(),
        tipo_persona: "Productor",
        informacion_personal: {
            nombre: `Productor Italiano ${i}`,
            fecha_nacimiento: new Date(1920 + (i % 60), (i % 12), (i % 28) + 1),
            lugar_nacimiento: "Italia",
            estado_civil: ["Soltero", "Casado", "Divorciado", "Viudo"][i % 4],
            contacto: {
                telefono: "+39-06-" + String(i + 300).padStart(6, '0'),
                email: `productor${i}@email.com`,
                direccion: `Via Nazionale ${i}`,
                ciudad: "Roma",
                pais: "Italia"
            }
        },
        informacion_produccion: {
            aportacion: 1000000 + (i * 500000),
            porcentaje_participacion: 10 + (i * 5),
            tipo_inversion: ["Inversión directa", "Coproducción", "Financiamiento"][i % 3],
            empresa: `Productora ${i} S.R.L.`
        },
        empresa_productora: `Productora ${i} S.R.L.`,
        tipo_productor: ["Ejecutivo", "Asociado", "Independiente"][i % 3],
        proyectos_activos: i % 5
    });
}

db.personas.insertMany(productores);
print("✅ Productores insertados: " + productores.length);

// Insertar película Cinema Paradiso
var cinema_paradiso_id = ObjectId();
var cinema_paradiso = {
    _id: cinema_paradiso_id,
    titulo: "Cinema Paradiso",
    resumen: "Un hombre maduro recuerda su infancia en un pequeño pueblo siciliano, donde desarrolló una amistad especial con el proyeccionista del cine local. A través de flashbacks, la película explora temas de nostalgia, pérdida de la inocencia y el poder transformador del cine. La historia sigue a Salvatore desde su juventud hasta la edad adulta, mostrando cómo el cine influyó en su vida y cómo las relaciones humanas dan forma a nuestro destino. Es una reflexión poética sobre el paso del tiempo, el amor y la memoria, envuelta en la magia del séptimo arte que conecta generaciones y culturas diferentes, creando un puente emocional entre el pasado y el presente que resuena en el corazón de cada espectador que ha vivido la experiencia transformadora del cine, convirtiéndose en una obra maestra que trasciende las barreras temporales y culturales para tocar la fibra más sensible del alma humana con su narrativa universal sobre la amistad, el crecimiento personal y el poder de los recuerdos que permanecen en nuestra memoria como tesoros invaluables que nos definen y nos conectan con nuestra esencia más profunda.",
    fecha_estreno: new Date("1988-11-17"),
    ranking: 4.8,
    duracion_minutos: 155,
    generos: ["Drama", "Romance", "Nostálgico"],
    idioma_original: "Italiano",
    pais_origen: "Italia",
    presupuesto: 5000000.00,
    recaudacion: 12000000.00,
    director: {
        director_id: tornatore_id,
        nombre: "Giuseppe Tornatore"
    },
    reparto: [
        {
            actor_id: cascio_id,
            actor_nombre: "Salvatore Cascio",
            tipo_actuacion: "Protagonista",
            personaje: "Salvatore (niño)",
            informacion_financiera: {
                salario_base: 1200000.00,
                bonificaciones: 150000.00,
                salario_total: 1350000.00,
                fecha_contrato: new Date("1988-03-15"),
                agente: "Agenzia Artisti Italiani"
            },
            fecha_inicio_rodaje: new Date("1988-05-01"),
            fecha_fin_rodaje: new Date("1988-08-30"),
            notas: "Debut cinematográfico extraordinario"
        },
        {
            actor_id: leonardi_id,
            actor_nombre: "Marco Leonardi",
            tipo_actuacion: "Protagonista",
            personaje: "Salvatore (joven)",
            informacion_financiera: {
                salario_base: 1800000.00,
                bonificaciones: 200000.00,
                salario_total: 2000000.00
            },
            fecha_inicio_rodaje: new Date("1988-05-01"),
            fecha_fin_rodaje: new Date("1988-08-30"),
            notas: "Papel secundario protagonista"
        },
        {
            actor_id: perrin_id,
            actor_nombre: "Jacques Perrin",
            tipo_actuacion: "Protagonista",
            personaje: "Salvatore (adulto)",
            informacion_financiera: {
                salario_base: 2500000.00,
                bonificaciones: 300000.00,
                salario_total: 2800000.00
            },
            fecha_inicio_rodaje: new Date("1988-06-15"),
            fecha_fin_rodaje: new Date("1988-07-15"),
            notas: "Papel narrativo principal"
        },
        {
            actor_id: noiret_id,
            actor_nombre: "Philippe Noiret",
            tipo_actuacion: "Protagonista",
            personaje: "Alfredo",
            informacion_financiera: {
                salario_base: 3200000.00,
                bonificaciones: 400000.00,
                salario_total: 3600000.00
            },
            fecha_inicio_rodaje: new Date("1988-05-01"),
            fecha_fin_rodaje: new Date("1988-08-30"),
            notas: "Papel central de la historia"
        }
    ],
    produccion: [
        {
            productor_id: cristaldi_id,
            productor_nombre: "Franco Cristaldi",
            informacion_produccion: {
                aportacion: 8500000.00,
                porcentaje_participacion: 65.00,
                tipo_inversion: "Inversión directa",
                empresa: "Vides Cinematografica"
            },
            rol_produccion: "Productor Ejecutivo",
            fecha_inicio: new Date("1987-12-01"),
            fecha_fin: new Date("1988-11-17")
        },
        {
            productor_id: romagnoli_id,
            productor_nombre: "Giovanna Romagnoli",
            informacion_produccion: {
                aportacion: 3200000.00,
                porcentaje_participacion: 35.00,
                tipo_inversion: "Coproducción",
                empresa: "Romagnoli Films"
            },
            rol_produccion: "Productora Asociada",
            fecha_inicio: new Date("1987-12-01"),
            fecha_fin: new Date("1988-11-17")
        }
    ],
    criticas: [
        {
            _id: ObjectId(),
            autor: "Mario Sesti",
            medio: "La Gazzetta dello Sport",
            fecha: new Date("1990-08-20"),
            contenido: "Una obra maestra del cine italiano que captura la esencia de la nostalgia con una maestría técnica excepcional. Tornatore logra crear una sinfonía visual que conecta emocionalmente con el espectador.",
            puntuacion: 4.8,
            sentimiento: "Muy Positivo",
            longitud_critica: 450
        },
        {
            _id: ObjectId(),
            autor: "Lietta Tornabuoni",
            medio: "Corriere della Sera",
            fecha: new Date("1990-08-25"),
            contenido: "Tornatore crea una sinfonía visual de emociones y recuerdos que trasciende las barreras del tiempo. Una película que celebra el poder transformador del cine.",
            puntuacion: 4.7,
            sentimiento: "Positivo",
            longitud_critica: 380
        },
        {
            _id: ObjectId(),
            autor: "Tullio Kezich",
            medio: "La Repubblica",
            fecha: new Date("1990-08-28"),
            contenido: "Un homenaje al poder del cine y a la memoria colectiva. Una obra que permanecerá en la historia del séptimo arte como referente indiscutible.",
            puntuacion: 4.9,
            sentimiento: "Muy Positivo",
            longitud_critica: 520
        }
    ],
    premios: [
        {
            _id: ObjectId(),
            nombre: "Palma de Oro",
            certamen: "Festival de Cannes",
            categoria: "Mejor Película",
            fecha_otorgamiento: new Date("1989-05-23"),
            tipo_certamen: "Internacional",
            prestigio: "Muy Alto",
            descripcion: "Premio principal del Festival de Cannes, considerado uno de los más prestigiosos del mundo."
        },
        {
            _id: ObjectId(),
            nombre: "Oscar a Mejor Película Extranjera",
            certamen: "Academia de Hollywood",
            categoria: "Película Extranjera",
            fecha_otorgamiento: new Date("1990-03-30"),
            tipo_certamen: "Internacional",
            prestigio: "Muy Alto",
            descripcion: "Reconocimiento de la Academia de Artes y Ciencias Cinematográficas de Hollywood."
        },
        {
            _id: ObjectId(),
            nombre: "David di Donatello",
            certamen: "Academia del Cine Italiano",
            categoria: "Mejor Película",
            fecha_otorgamiento: new Date("1989-07-15"),
            tipo_certamen: "Nacional",
            prestigio: "Alto",
            descripcion: "Premio más importante del cine italiano, equivalente al Oscar."
        }
    ],
    metadatos: {
        fecha_creacion: new Date(),
        fecha_actualizacion: new Date(),
        version: "1.0",
        autor_documento: "Sistema BDA ESCOM",
        fuente: "Base de datos cinematográfica ESCOM"
    }
};

db.peliculas.insertOne(cinema_paradiso);
print("✅ Cinema Paradiso insertada exitosamente");

print("🎬 Base de datos poblada completamente");
print("📊 Resumen:");
print("- Directores: " + db.personas.countDocuments({tipo_persona: "Director"}));
print("- Actores: " + db.personas.countDocuments({tipo_persona: "Actor"}));
print("- Productores: " + db.personas.countDocuments({tipo_persona: "Productor"}));
print("- Películas: " + db.peliculas.countDocuments());
print("- Total personas: " + db.personas.countDocuments());
