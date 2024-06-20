import * as Clippy from "clippy";
import {
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";

export default function App() {
  const handleButton = async () => {
    if (Platform.OS === "ios") {
      const path = await Clippy.open("https://picsum.photos/200/300", {
        wide: false,
      });

      console.log(path);
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity onPress={() => handleButton()}>
        <Text>Hola</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
