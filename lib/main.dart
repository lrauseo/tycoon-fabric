import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
import 'screens/employee_management_screen.dart';
import 'screens/production_management_screen.dart';
import 'screens/distribution_management_screen.dart';

void main() {
  runApp(TycoonFabricApp());
}

class TycoonFabricApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tycoon Fabric',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.factory,
              size: 120,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'TYCOON FABRIC',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Do Workshops ao Império Industrial',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Tycoon Fabric'),
        backgroundColor: Colors.brown[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown[700]!, Colors.brown[50]!],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40),
              Icon(
                Icons.factory,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'Bem-vindo ao Tycoon Fabric!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Construa seu império industrial',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 60),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildMenuCard(
                        context,
                        'Novo Jogo',
                        'Comece uma nova fábrica',
                        Icons.play_arrow,
                        Colors.green,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameScreen()),
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildMenuCard(
                        context,
                        'Como Jogar',
                        'Aprenda as mecânicas do jogo',
                        Icons.help_outline,
                        Colors.blue,
                        () => _showHowToPlay(context),
                      ),
                      SizedBox(height: 16),
                      _buildMenuCard(
                        context,
                        'Sobre',
                        'Informações sobre o jogo',
                        Icons.info_outline,
                        Colors.orange,
                        () => _showAbout(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 30,
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Como Jogar'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🏭 Objetivo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Transforme uma pequena oficina em um império industrial!'),
              SizedBox(height: 16),
              
              Text(
                '👥 Funcionários',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('• Contrate funcionários para operar suas linhas de produção\n'
                   '• Treine-os para aumentar sua produtividade\n'
                   '• Mantenha-os satisfeitos para evitar greves'),
              SizedBox(height: 16),
              
              Text(
                '🏭 Produção',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('• Adicione linhas de produção para diferentes produtos\n'
                   '• Gerencie materiais e estoques\n'
                   '• Otimize a eficiência das suas linhas'),
              SizedBox(height: 16),
              
              Text(
                '🚚 Distribuição',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('• Aceite contratos de clientes\n'
                   '• Escolha métodos de transporte adequados\n'
                   '• Gerencie custos logísticos'),
              SizedBox(height: 16),
              
              Text(
                '💰 Economia',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('• Gerencie seu dinheiro cuidadosamente\n'
                   '• Pague salários mensalmente\n'
                   '• Invista em crescimento'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendi!'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sobre o Tycoon Fabric'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Versão 1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Um jogo de simulação industrial onde você constrói e gerencia '
              'sua própria fábrica, desde uma pequena oficina até uma grande corporação.',
            ),
            SizedBox(height: 16),
            Text(
              'Desenvolvido com Flutter + Flame\n'
              'Criado para demonstrar conceitos de gestão empresarial de forma divertida.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }
}