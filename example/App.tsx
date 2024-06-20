import { StyleSheet, Text, View } from 'react-native';

import * as Clippy from 'clippy';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{Clippy.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
