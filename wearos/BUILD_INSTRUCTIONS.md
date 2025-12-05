# Instruções de Build para Wear OS

## Pré-requisitos

1. Android SDK 26+ instalado
2. Wear OS System Images no AVD Manager
3. Flutter 3.0+

## Como usar a pasta `wearos/` para builds separadas

### Opção 1: Build direto com Flutter (recomendado)

```bash
cd C:\BioSync\BioSync_flutter_apk

# Build para Wear OS (emulador)
flutter run -d emulator-5554

# Ou especificar caminho customizado
flutter build apk --target-platform=android-arm --split-per-abi
```

### Opção 2: Usar Gradle diretamente

```bash
cd C:\BioSync\BioSync_flutter_apk\wearos

# Build Wear OS APK
./gradlew.bat assembleDebug

# Output estará em: app/build/outputs/apk/debug/
```

### Opção 3: Build em paralelo (Android + Wear OS)

Terminal 1 - Android:
```bash
cd android
./gradlew.bat assembleDebug
```

Terminal 2 - Wear OS:
```bash
cd wearos
./gradlew.bat assembleDebug
```

## APKs Gerados

- **Android**: `android/app/build/outputs/apk/debug/app-debug.apk`
- **Wear OS**: `wearos/app/build/outputs/apk/debug/app-debug.apk`

Ambos podem coexistir sem conflito!

## Testing em Dispositivos

### Emulador Wear OS
```bash
# Listar emuladores disponíveis
flutter devices

# Run no Wear OS
flutter run -d <device-id>
```

### Relógio Real (via adb)
```bash
# Conectar relógio por USB
adb devices

# Instalar APK
adb install -r wearos/app/build/outputs/apk/debug/app-debug.apk

# Executar
adb shell am start com.example.biosync.wear/.MainActivity
```

## Nota Importante

A estrutura `wearos/` é uma **build paralela**. A UI em Dart é compartilhada, mas:
- Gradle, manifests e dependências nativas são isoladas
- Sem risco de conflito com a build Android principal
- Cada APK tem seu próprio package ID (`com.example.biosync` vs `com.example.biosync.wear`)
