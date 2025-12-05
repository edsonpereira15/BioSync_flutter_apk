import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/device_helper.dart';

// --- MODELO DE DADOS ---
class DisposalPointModel {
  final String name;
  final String address;
  final String category;
  final String distanceString; // Ex: "1.2 km" (para exibição)
  final double distanceValue; // Ex: 1.2 (para cálculo de filtro)
  final String status;
  final Color statusColor;
  final IconData icon;
  final String description;
  final String openingHours;

  DisposalPointModel({
    required this.name,
    required this.address,
    required this.category,
    required this.distanceString,
    required this.distanceValue,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.description,
    required this.openingHours,
  });
}

class PontoDescartePage extends StatefulWidget {
  const PontoDescartePage({super.key});

  static const String routePath = '/pontoDescarte';

  @override
  State<PontoDescartePage> createState() => _PontoDescartePageState();
}

class _PontoDescartePageState extends State<PontoDescartePage> {
  // Cores do Design
  static const Color primaryGreen = Color(0xFF50E18A);
  static const Color darkText = Color(0xFF333333);

  // Controladores
  final TextEditingController _searchController = TextEditingController();

  // Variáveis de Estado para os filtros
  String? _selectedCategory;
  String? _selectedDistance; // Ex: "5 km"

  // --- DADOS MOCKADOS ---
  final List<DisposalPointModel> _allPoints = [
    DisposalPointModel(
      name: 'EcoPonto Central',
      address: 'Rua das Flores, 123 - Centro',
      category: 'Eletrônicos',
      distanceString: '1.2 km',
      distanceValue: 1.2,
      status: 'Aberto',
      statusColor: primaryGreen,
      icon: Icons.recycling,
      description: 'Aceitamos baterias, celulares antigos e cabos.',
      openingHours: '08:00 - 18:00',
    ),
    DisposalPointModel(
      name: 'Reciclagem Verde',
      address: 'Rua Limpa, 789 - Vila Verde',
      category: 'Papel',
      distanceString: '2.8 km',
      distanceValue: 2.8,
      status: 'Fechado',
      statusColor: Colors.orange,
      icon: Icons.delete_outline,
      description: 'Especializado em papelão, jornais e revistas.',
      openingHours: '09:00 - 17:00',
    ),
    DisposalPointModel(
      name: 'Vidros Express',
      address: 'Av. Transparente, 55 - Vidraçaria',
      category: 'Vidro',
      distanceString: '3.5 km',
      distanceValue: 3.5,
      status: 'Aberto',
      statusColor: primaryGreen,
      icon: Icons.wine_bar,
      description: 'Recebemos garrafas e potes de vidro limpos.',
      openingHours: '08:00 - 12:00',
    ),
    DisposalPointModel(
      name: 'Centro de Triagem Norte',
      address: 'Rodovia BR-101, Km 20',
      category: 'Metal',
      distanceString: '10.0 km',
      distanceValue: 10.0,
      status: 'Aberto',
      statusColor: primaryGreen,
      icon: Icons.build,
      description: 'Recebemos latas de alumínio, ferro velho e cobre.',
      openingHours: '07:00 - 19:00',
    ),
    DisposalPointModel(
      name: 'Plásticos do Futuro',
      address: 'Rua do Polímero, 99',
      category: 'Plástico',
      distanceString: '15.0 km',
      distanceValue: 15.0,
      status: 'Aberto',
      statusColor: primaryGreen,
      icon: Icons.local_drink,
      description: 'PET, tampinhas e embalagens plásticas limpas.',
      openingHours: '08:00 - 17:00',
    ),
  ];

  // Lista filtrada que aparece na tela
  late List<DisposalPointModel> _filteredPoints;

  @override
  void initState() {
    super.initState();
    _filteredPoints = _allPoints; // Inicia mostrando tudo
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE FILTRAGEM CENTRALIZADA ---
  void _applyFilters() {
    List<DisposalPointModel> tempPoints = _allPoints;

    // 1. Filtro por Texto (Nome)
    if (_searchController.text.isNotEmpty) {
      tempPoints = tempPoints
          .where((point) => point.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // 2. Filtro por Categoria
    if (_selectedCategory != null && _selectedCategory != 'Todas') {
      tempPoints = tempPoints
          .where((point) => point.category == _selectedCategory)
          .toList();
    }

    // 3. Filtro por Distância (Raio Máximo)
    if (_selectedDistance != null) {
      // Extrai o número da string "5 km" -> 5.0
      double maxDistance =
          double.tryParse(_selectedDistance!.split(' ')[0]) ?? 100.0;

      tempPoints = tempPoints.where((point) {
        return point.distanceValue <= maxDistance;
      }).toList();
    }

    setState(() {
      _filteredPoints = tempPoints;
    });
  }

  // Função para resetar filtros individuais (opcional, usada no ícone 'X')
  void _clearCategory() {
    setState(() {
      _selectedCategory = null;
    });
    _applyFilters();
  }

  void _clearDistance() {
    setState(() {
      _selectedDistance = null;
    });
    _applyFilters();
  }

  // --- MODAL DE DETALHES ---
  void _showPointDetails(BuildContext context, DisposalPointModel point) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: point.statusColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(point.icon, size: 40, color: point.statusColor),
                ),
                const SizedBox(height: 16),
                Text(
                  point.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.interTight(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        point.address,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                _buildModalRow(Icons.category, 'Categoria:', point.category),
                const SizedBox(height: 10),
                _buildModalRow(
                    Icons.access_time, 'Horário:', point.openingHours),
                const SizedBox(height: 10),
                _buildModalRow(Icons.info_outline, 'Status:', point.status,
                    color: point.status == 'Aberto'
                        ? const Color.fromARGB(255, 80, 225, 138)
                        : const Color.fromARGB(255, 221, 139, 15)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    point.description,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(
                        fontSize: 14, color: Colors.grey[800]),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Fechar',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalRow(IconData icon, String label, String value,
      {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text(label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, color: darkText)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
                color: color ?? Colors.grey[800],
                fontWeight:
                    color != null ? FontWeight.bold : FontWeight.normal),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWear = DeviceHelper.isWearOS(context);
    final isSmall = DeviceHelper.isSmallScreen(context);
    final padding = DeviceHelper.getAdaptivePadding(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 238),

      // --- 1. MENU LATERAL ---
      drawer: isWear
          ? null // Sem drawer em Wear OS
          : Drawer(
              backgroundColor: Color.fromARGB(255, 238, 238, 238),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: primaryGreen),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                    'assets/logo-bio-sync-login.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => const Icon(
                                        Icons.eco,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    text: 'Home',
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 158, 158, 158)
                        .withOpacity(0.2),
                    child: _buildDrawerItem(
                      icon: Icons.business_outlined,
                      text: 'Pontos de Descarte',
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_month_outlined,
                    text: 'Agendamentos',
                    onTap: () => Navigator.pushNamed(context, '/agendamento'),
                  ),
                ],
              ),
            ),

      // --- 2. APPBAR ---
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 80, 225, 138),
        elevation: isWear ? 0 : 10,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isWear
            ? Text('Pontos',
                style:
                    GoogleFonts.interTight(fontSize: 14, color: Colors.white))
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/perfil'),
            onLongPress: () => Navigator.pushNamed(context, '/perfil'),
            color: Colors.white,
            tooltip: 'Perfil',
            iconSize: isWear ? 20 : 30,
          ),
        ],
      ),

      // --- 3. CORPO ---
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: padding,
                child: Column(
                  children: [
                    // A. Barra de Busca (oculta em Wear OS)
                    if (!isWear)
                      SizedBox(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) =>
                              _applyFilters(), // Filtra ao digitar
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: isSmall ? 12 : 14),
                          decoration: InputDecoration(
                            hintText: 'Buscar pontos...',
                            prefixIcon: const Icon(Icons.search),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: isWear ? 4 : 8),
                          ),
                        ),
                      ),

                    SizedBox(height: isWear ? 6 : 12),

                    // B. Filtros Funcionais - Responsivo
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 400;
                        return isMobile || isWear
                            ? Column(
                                children: [
                                  _buildDropdownFilter(
                                    hint: 'Categoria',
                                    value: _selectedCategory,
                                    items: [
                                      'Eletrônicos',
                                      'Papel',
                                      'Plástico',
                                      'Metal',
                                      'Vidro'
                                    ],
                                    onChanged: (val) {
                                      setState(() => _selectedCategory = val);
                                      _applyFilters();
                                    },
                                    onClear: _clearCategory,
                                  ),
                                  SizedBox(height: isWear ? 4 : 8),
                                  _buildDropdownFilter(
                                    hint: 'Distância',
                                    value: _selectedDistance,
                                    items: ['1 km', '5 km', '10 km', '20 km'],
                                    onChanged: (val) {
                                      setState(() => _selectedDistance = val);
                                      _applyFilters();
                                    },
                                    onClear: _clearDistance,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _buildDropdownFilter(
                                      hint: 'Categoria',
                                      value: _selectedCategory,
                                      items: [
                                        'Eletrônicos',
                                        'Papel',
                                        'Plástico',
                                        'Metal',
                                        'Vidro'
                                      ],
                                      onChanged: (val) {
                                        setState(() => _selectedCategory = val);
                                        _applyFilters();
                                      },
                                      onClear: _clearCategory,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: _buildDropdownFilter(
                                      hint: 'Distância',
                                      value: _selectedDistance,
                                      items: ['1 km', '5 km', '10 km', '20 km'],
                                      onChanged: (val) {
                                        setState(() => _selectedDistance = val);
                                        _applyFilters();
                                      },
                                      onClear: _clearDistance,
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),

                    SizedBox(height: isWear ? 6 : 12),

                    // C. Mapa Estático (oculto em Wear OS)
                    if (!isWear)
                      Container(
                        width: double.infinity,
                        height: isSmall ? 120 : 140,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2))
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined,
                                size: isSmall ? 32 : 40, color: primaryGreen),
                            SizedBox(height: isSmall ? 4 : 6),
                            Text(
                              'Mapa dos Pontos',
                              style: GoogleFonts.interTight(
                                fontSize: isSmall ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: darkText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Visualize os pontos próximos',
                              style: GoogleFonts.inter(
                                  fontSize: isSmall ? 10 : 11,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // D. Lista Filtrada
            Expanded(
              child: _filteredPoints.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum ponto encontrado.',
                        style: GoogleFonts.inter(
                            color: Colors.black, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredPoints.length,
                      itemBuilder: (context, index) {
                        final point = _filteredPoints[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDisposalCard(point),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        text,
        style: GoogleFonts.inter(
            color: textColor, fontWeight: FontWeight.w500, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  // Dropdown com botão de limpar
  Widget _buildDropdownFilter({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required VoidCallback onClear,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(hint,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                isExpanded: true,
                dropdownColor: Colors.white,
                items: items
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item,
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: Colors.black54)),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
          if (value != null) // Mostra o X se tiver valor selecionado
            GestureDetector(
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close, size: 16, color: Colors.red),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildDisposalCard(DisposalPointModel point) {
    return InkWell(
      onTap: () => _showPointDetails(context, point),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF50E18A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(point.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.name,
                    style: GoogleFonts.interTight(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    point.address,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTag(point.category, const Color(0xFF50E18A),
                            fontSize: 9),
                        const SizedBox(width: 6),
                        _buildTag(point.distanceString,
                            Color.fromARGB(255, 217, 217, 217),
                            textColor: Colors.black54, fontSize: 9),
                        const SizedBox(width: 6),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 12, color: point.statusColor),
                            const SizedBox(width: 3),
                            Text(
                              point.status,
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: point.statusColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color,
      {Color textColor = Colors.white, double fontSize = 10}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
            color: textColor, fontSize: fontSize, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
