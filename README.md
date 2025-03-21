# 🐺 EPSI B3 - TP Noté SQL Server 2025

> Jeu multijoueur massivement distribué : Loups vs Villageois

## 👥 Auteurs

- Github : Ozomozyan
- Github : WannaGetSlow



## 🎯 Objectif

Ce projet est un TP noté basé sur la manipulation de bases de données SQL Server pour simuler un jeu Loups/Villageois en environnement multijoueur et tolérant aux pannes.

---

## 🗂️ Structure du dépôt

| Fichier           | Description                                              |
| ----------------- | -------------------------------------------------------- |
| `wv_schema.sql`   | Création du schéma de base (tables)                      |
| `wv_index.sql`    | Ajout de contraintes, clés primaires/étrangères et index |
| `wv_views.sql`    | Création des vues                                        |
| `wv_funcs.sql`    | Création des fonctions                                   |
| `wv_procs.sql`    | Création des procédures stockées                         |
| `wv_triggers.sql` | Création des triggers                                    |

---

## 🧪 Exécution avec Docker

### Prérequis

- **Docker** installé et configuré.
- Un conteneur SQL Server (ex. nommé `sql1`) doit être en cours d'exécution.
- Les fichiers SQL doivent être placés dans votre dossier de travail (ex. `C:\Users\VotreNom\Desktop\SGBD`).

### Étapes pour exécuter chaque fichier SQL

1. **Copier le fichier dans le conteneur Docker** :

```bash
docker cp chemin\vers\fichier.sql sql1:/fichier.sql
```

2. **Exécuter le script dans le conteneur** :

```bash
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "YourStrong!Pass123" -d master -i /fichier.sql
```

> Remplace `fichier.sql` par chacun des fichiers du projet : `wv_schema.sql`, `wv_index.sql`, etc.

---

## 🧪 Exécution locale (alternative)

### Prérequis

- SQL Server Management Studio (SSMS) ou un autre outil SQL compatible
- Base `LoupsTP` déjà créée dans SQL Server

### Étapes dans SSMS ou Visual Studio

1. Ouvrir chaque fichier `.sql` dans l'ordre suivant :

   - `wv_schema.sql`
   - `wv_index.sql`
   - `wv_views.sql`
   - `wv_funcs.sql`
   - `wv_procs.sql`
   - `wv_triggers.sql`

2. Exécuter chaque script dans la base `LoupsTP`.

---

## 💡 Remarques

- Les noms des fichiers, fonctions, procédures et vues doivent être respectés à la lettre.
- Toutes les requêtes sont compatibles avec SQL Server 2019+
- Le projet respecte les principes de modularité et d’abstraction (les applications ne dépendent pas directement des tables)

