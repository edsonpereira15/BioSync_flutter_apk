import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // NOVO: Pacote de autenticação
import 'firebase_options.dart';
// Import das Páginas (Ajustado conforme sua pasta)
import 'pages/login_page.dart';
import 'pages/cadastro_page.dart';
import 'pages/agendamento_page.dart';
import 'pages/pontoDescarte_page.dart';
import 'pages/home_page.dart';
// Import dos Formulários
import 'pages/Forms/cadastro_usuario_page.dart';
import 'pages/Forms/cadastro_ponto_page.dart';

// --- FUNÇÃO MAIN ATUALIZADA COM INICIALIZAÇÃO DO FIREBASE ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BiosyncApp());
}

class BiosyncApp extends StatelessWidget {
  const BiosyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biosync',
      debugShowCheckedModeBanner: false,

      // --- TEMA GLOBAL SIMPLIFICADO ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        // Cor Semente (Verde Principal)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF50E18A),
          primary: const Color(0xFF50E18A),
          background: const Color(0xFFEEEEEE),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF50E18A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF50E18A), width: 2),
          ),
        ),
      ),

      // --- ROTAS DE NAVEGAÇÃO ---
      // Mantemos as rotas para navegação PUSH
      routes: {
        LoginPage.routePath: (context) => const LoginPage(),
        CadastroPage.routePath: (context) => const CadastroPage(),
        AgendamentoPage.routePath: (context) => const AgendamentoPage(),
        PontoDescartePage.routePath: (context) => const PontoDescartePage(),
        HomePage.routePath: (context) => const HomePage(),

        // Formulários de Cadastro
        // NOTE: Mantenha esses caminhos literais para simplificar
        '/formRegisterCommunity': (context) =>
            const CadastroUsuarioPage(tipoUsuario: 'Morador'),
        '/formRegisterCollector': (context) =>
            const CadastroUsuarioPage(tipoUsuario: 'Coletor'),
        '/formRegisterDisposal': (context) => const CadastroPontoPage(),
      },

      // --- DEFINIÇÃO DA TELA INICIAL (HOME) ---
      // Substitui 'initialRoute' e define qual tela carregar primeiro com base na autenticação.
      home: StreamBuilder<User?>(
        // Observa mudanças no estado de autenticação (login, logout, etc.)
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Enquanto a conexão está sendo estabelecida, mostra um loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Color(0xFF50E18A),
              )),
            );
          }

          // 2. Se o usuário estiver autenticado (snapshot.hasData é true)
          if (snapshot.hasData) {
            // Leva para a Home Page
            return const HomePage();
          }

          // 3. Caso contrário (usuário deslogado ou primeira abertura)
          // Leva para a Login Page
          return const LoginPage();
        },
      ),
    );
  }
}
