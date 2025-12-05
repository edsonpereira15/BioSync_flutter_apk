# Wear OS Build Directory

Esta pasta contém a configuração de build específica para **Wear OS** (Android Wear).

## Estrutura

```
wearos/
├── app/
│   ├── build.gradle.kts          # Build configuration para Wear OS
│   ├── src/
│   │   └── main/
│   │       └── AndroidManifest.xml  # Manifest com uses-feature para watch
├── gradle.properties             # Gradle properties
├── settings.gradle.kts           # Settings gradle
├── gradlew                        # Linux/Mac gradle wrapper
└── gradlew.bat                    # Windows gradle wrapper
```

## Diferenças do Android Principal

1. **Package ID**: `com.example.biosync.wear` (vs `com.example.biosync`)
2. **minSdk**: 26 (Wear OS requer SDK 26+)
3. **uses-feature**: 
   - `android.hardware.type.watch` (required=true)
   - `android.hardware.screen.round` (required=false, para suporte a telas redondas)
4. **Permissions**: Somente permissões essenciais para Wear OS

## Como Usar

### Build para Wear OS
```bash
flutter build apk --split-per-abi -t lib/main.dart
```

### Build paralelo com Android
- O Android principal builds em `android/`
- Wear OS builds em `wearos/`
- Não há conflito entre as builds

### Testing em Emulador Wear OS
```bash
flutter run -d emulator-wear-os
```

## Configuração Firebase para Wear OS

Se precisar de Firebase específico para Wear OS:
1. Adicione `google-services.json` em `wearos/app/`
2. Configure credenciais diferentes se necessário

## Notes

- O código Dart é compartilhado entre Android e Wear OS
- Apenas as configurações nativas (Gradle, Manifest) são separadas
- Para adaptar UI por tamanho de tela, use `MediaQuery.of(context).size` no Dart
