


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore fireStore = FirebaseFirestore.instance;
User ? currentUser = auth.currentUser ;

// collection

const usersCollection = 'users';
const productsCollections = 'products';
const cartCollections = 'cart';
const chatsCollection = 'chats';
const messagesCollections = 'messages';
const ordersCollection = 'orders';
const vendorsCollection = 'vendors';
