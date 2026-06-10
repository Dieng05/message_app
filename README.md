# AstaChat

Application de messagerie instantanée que nous avons développée avec **Flutter** et **Firebase**, permettant aux utilisateurs de l'application de s'inscrire, se connecter, d'ajouter leurs contacts et échanger des messages en temps réel.

---

## Fonctionnalités

- **Inscription / Connexion** via Firebase Authentication (email + mot de passe)
- **Gestion du profil** : modifier son prénom, nom et email se déconnecter
- **Contacts** : ajouter un contact par email (vérifié dans la base), liste alphabétique avec avatar coloré
- **Messagerie en temps réel** : envoi et réception de messages instantanés via Firestore
- **Conversations** : liste des conversations triées par date, aperçu du dernier message
- **Réception de messages d'inconnus** : les messages reçus d'utilisateurs non enregistrés dans les contacts s'affichent avec une option pour ajouter rapidement le contact. 
- **Recherche** : filtrage des contacts et des conversations

---

## Structure du projet

```
lib/
├── main.dart                        # Point d'entrée, initialisation Firebase, routes
├── firebase_options.dart            # Configuration Firebase par plateforme
│
├── models/                          # Modèles de données
│   ├── User.dart                    # Modèle utilisateur (uid, prénom, nom, email)
│   ├── MessageModel.dart            # Modèle message (idFrom, idTo, contenu, timestamp)
│   └── ContactModel.dart            # Modèle contact (nom, email, avatar, couleur)
│
├── services/                        # Couche d'accès aux données Firebase
│   ├── ServiceConnection.dart       # Auth Firebase + gestion des comptes utilisateurs
│   ├── ChatService.dart             # Envoi/réception de messages, flux de conversations
│   └── ContactService.dart         # Sauvegarde et lecture des contacts Firestore
│
├── pages/                           # Écrans complets de l'application
│   ├── Acceuil.dart                 # Page d'accueil (Se connecter / Créer un compte)
│   ├── UserConnection.dart          # Page de connexion
│   ├── UserRegister.dart            # Page d'inscription
│   ├── UserProfil.dart              # Page de profil utilisateur
│   ├── message.dart                 # Liste des conversations
│   ├── contact.dart                 # Liste des contacts
│   ├── discussion.dart              # Écran de chat (échange de messages)
│   └── add_contact.dart             # Formulaire d'ajout de contact
│
├── widgets/                         # Composants réutilisables
│   ├── navigation.dart              # Barre de navigation inférieure
│   ├── Form/
│   │   ├── ConnectionForm.dart      # Formulaire de connexion
│   │   └── RegisterForm.dart        # Formulaire d'inscription
│   ├── contact/
│   │   └── list_contact.dart        # Liste des contacts groupés par lettre
│   ├── discussion/
│   │   ├── chat_bubble.dart         # Bulle de message (envoyé / reçu)
│   │   └── chat_input_bar.dart      # Barre de saisie de message
│   └── message/
│       ├── conversation_tile.dart   # Tuile d'une conversation dans la liste
│       ├── contact_story_item.dart  # Avatar cliquable en haut de la liste
│       └── message_search_bar.dart  # Barre de recherche
│
```

---

## Architecture

L'application suit une architecture en **couches** :

```
Pages / Widgets  ──►  Services  ──►  Firebase (Auth + Firestore)
```

- **Pages** : gèrent l'état local et les interactions utilisateur
- **Services** : encapsulent toute la logique Firebase (requêtes, streams, mutations)
- **Modèles** : objets de données purs, sérialisables depuis/vers Firestore
- **Widgets** : composants d'interface indépendants, paramétrables via leur constructeur

La mise à jour de l'interface en temps réel repose sur les **Streams Firestore** consommés via `StreamBuilder` ou `StreamSubscription`.

---

## Liaison Firebase

### Structure Firestore

```
Firestore
├── users/
│   ├── {uid}/                        # Document utilisateur (clé = UID Firebase Auth)
│   │   ├── uid: string
│   │   ├── firstName: string
│   │   ├── lastName: string
│   │   └── email: string
│   │
│   └── {email}/                      # Document de contacts (clé = email du propriétaire)
│       └── contacts/
│           └── {contactEmail}/       # Un document par contact
│               ├── name: string
│               └── email: string
│
└── conversations/
    └── {convId}/                     # ID = emailA + "_" + emailB (triés alphabétiquement)
        ├── participants: [emailA, emailB]
        ├── lastMessage: string
        ├── lastTimestamp: Timestamp
        ├── lastSenderId: string
        └── messages/
            └── {msgId}/
                ├── idFrom: string
                ├── idTo: string
                ├── content: string
                ├── timestamp: Timestamp
                └── type: int
```


## Widgets réutilisables

### `BottomNavBar` — `widgets/navigation.dart`
Barre de navigation inférieure commune à toutes les pages principales.
- Paramètre `currentIndex` pour indiquer l'onglet actif
- 3 onglets : Messages (0), Contacts (1), Profil (2)
- Couleur indicatrice rouge

### `ChatBubble` — `widgets/discussion/chat_bubble.dart`
Bulle d'affichage d'un message dans la conversation.
- Alignée à droite si `isMine: true`, à gauche sinon
- Fond rouge pour les messages envoyés, blanc pour les reçus
- Affiche le contenu et l'heure formatée

### `ChatInputBar` — `widgets/discussion/chat_input_bar.dart`
Barre de saisie en bas de l'écran de discussion.
- Contrôlée via un `TextEditingController`
- Bouton d'envoi déclenche le callback `onSend`

### `ConversationTile` — `widgets/message/conversation_tile.dart`
Tuile représentant une conversation dans la liste.
- Avatar avec initiales et couleur déterministe
- Aperçu du dernier message avec préfixe "moi :" si envoyé par soi
- Si `isUnknown: true` : affiche une icône `person_add` pour ajouter le contact
- Callbacks `onTap` (ouvrir la discussion) et `onAddContact` (enregistrer l'inconnu)

### `ListContact` — `widgets/contact/list_contact.dart`
Liste des contacts groupée alphabétiquement.
- Flux temps réel depuis `ContactService`
- Filtrable via `searchQuery`
- Sections par lettre avec avatar coloré et initiales

### `MessageSearchBar` — `widgets/message/message_search_bar.dart`
Barre de recherche stylisée (fond gris, coins arrondis, icône loupe).
- Contrôlée via `TextEditingController`

### `ContactModel` — `models/ContactModel.dart`
Modèle de contact avec deux propriétés calculées :
- `initial` : initiales du prénom et nom pour l'avatar
- `color` : couleur déterministe parmi 12 couleurs calculée à partir du nom (hash des codes Unicode)

---

## Packages utilisés

| Package | Version | Rôle |
|---------|---------|------|
| `firebase_core` | ^3.0.0 | Initialisation de Firebase dans l'application Flutter |
| `firebase_auth` | ^5.0.0 | Authentification : inscription, connexion, déconnexion, réinitialisation du mot de passe |
| `cloud_firestore` | ^5.0.0 | Base de données NoSQL temps réel : stockage des utilisateurs, contacts, messages et conversations avec streams en direct |
| `flutter_launcher_icons` | ^0.14.3 | Génération automatique des icônes de l'application pour Android et iOS à partir d'une image source |
| `cupertino_icons` | ^1.0.8 | Pack d'icônes style iOS disponibles dans les widgets Flutter |
| `flutter_lints` | ^6.0.0 | Règles d'analyse statique pour garantir la qualité et la cohérence du code Dart |

---

## Lancer le projet

### Prérequis
- Flutter SDK >= 3.10
- Un projet Firebase configuré avec **Authentication** (Email/Password) et **Firestore** activés
- Fichier `google-services.json` placé dans `android/app/`
- Fichier `firebase_options.dart` généré via FlutterFire CLI (`flutterfire configure`)

### Installation


```bash
flutter pub get
flutter run
```

### Générer les icônes de l'app

```bash
dart run flutter_launcher_icons
```


## perpective
- mise à jour du mots de pass.
- story time
- création de groupe de discusion