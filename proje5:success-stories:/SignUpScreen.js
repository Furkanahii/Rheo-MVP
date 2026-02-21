import React, { useState } from "react";
import { View, TextInput, Button, Text, StyleSheet } from "react-native";
import { createUserWithEmailAndPassword } from "firebase/auth";
import { auth } from "../firebaseConfig";

const SignUpScreen = ({ navigation }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSignUp = async () => {
    try {
      await createUserWithEmailAndPassword(auth, email, password);
      navigation.navigate("Login");
    } catch (error) {
      setError(error.message);
    }
  };

  return (
    <View style={styles.container}>
      <Text>Kayıt Ol</Text>
      <TextInput placeholder="E-posta" value={email} onChangeText={setEmail} style={styles.input} />
      <TextInput placeholder="Şifre" value={password} onChangeText={setPassword} style={styles.input} secureTextEntry />
      <Button title="Kayıt Ol" onPress={handleSignUp} />
      {error ? <Text style={styles.error}>{error}</Text> : null}
      <Button title="Giriş Yap" onPress={() => navigation.navigate("Login")} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: "center", alignItems: "center" },
  input: { width: 300, height: 40, borderWidth: 1, marginVertical: 10, paddingHorizontal: 8 },
  error: { color: "red", marginTop: 10 }
});

export default SignUpScreen;
