import 'package:flutter/material.dart';

void main() => runApp(const ExploreMundoApp());

class ExploreMundoApp extends StatelessWidget {
  const ExploreMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Explore Mundo - Agência de Viagens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroBusca = '';

  final List<Map<String, String>> _destinos = [
    {
      'imagem': 'images/destino1.jpg',
      'titulo': 'Pacote Serra Catarinense & Litoral',
      'local': 'Santa Catarina, Brasil - Explore Mundo',
      'avaliacao': '4.9',
      'descricao':
          'Explore novos horizontes com a agência Explore Mundo. Este pacote exclusivo inclui hospedagem completa, passeios guiados pelos principais pontos turísticos, translado e suporte 24 horas.',
    },
    {
      'imagem': 'images/destino2.jpg',
      'titulo': 'Roteiro Histórico e Cultural',
      'local': 'Europa Clássica - Explore Mundo',
      'avaliacao': '4.8',
      'descricao':
          'Descubra paisagens inesquecíveis, arquitetura histórica e gastronomia local com guias especializados e roteiros personalizados para toda a família.',
    },
    {
      'imagem': 'images/destino3.jpg',
      'titulo': 'Aventura & Natureza Exuberante',
      'local': 'América do Sul - Explore Mundo',
      'avaliacao': '5.0',
      'descricao':
          'Conecte-se com a natureza em trilhas ecológicas, passeios de barco e hospedagens sustentáveis com todo o conforto e segurança da Explore Mundo.',
    },
  ];

  int _indiceAtual = 0;

  Column _buildButtonColumn(
      Color color, IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onTap,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final destinosFiltrados = _destinos.where((d) {
      return d['titulo']!.toLowerCase().contains(_filtroBusca.toLowerCase()) ||
          d['local']!.toLowerCase().contains(_filtroBusca.toLowerCase());
    }).toList();

    final destinoAtivo = destinosFiltrados.isNotEmpty
        ? destinosFiltrados[_indiceAtual % destinosFiltrados.length]
        : _destinos[0];

    Color color = Theme.of(context).primaryColor;

    // Seção de Título
    Widget titleSection = Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    destinoAtivo['titulo']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  destinoAtivo['local']!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text(destinoAtivo['avaliacao']!),
        ],
      ),
    );

    // Seção de Botões
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.call, 'CONTATO',
            () => _mostrarMensagem('Ligando para a central Explore Mundo...')),
        _buildButtonColumn(color, Icons.near_me, 'DESTINOS', () {
          setState(() {
            _indiceAtual = (_indiceAtual + 1) % _destinos.length;
          });
        }),
        _buildButtonColumn(color, Icons.share, 'COMPARTILHAR',
            () => _mostrarMensagem('Link do pacote copiado!')),
      ],
    );

    // Seção de Texto
    Widget textSection = Container(
      padding: const EdgeInsets.all(24),
      child: Text(
        destinoAtivo['descricao']!,
        softWrap: true,
        textAlign: TextAlign.justify,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Mundo'),
        actions: [
          TextButton(
            onPressed: () => _mostrarMensagem('Seção: Destinos'),
            child: const Text('Destinos'),
          ),
          TextButton(
            onPressed: () => _mostrarMensagem('Seção: Pacotes'),
            child: const Text('Pacotes'),
          ),
          TextButton(
            onPressed: () => _mostrarMensagem('Seção: Contato'),
            child: const Text('Contato'),
          ),
          TextButton(
            onPressed: () => _mostrarMensagem('Agência Explore Mundo'),
            child: const Text('Sobre nós'),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Campo de Pesquisa Rápida
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar destinos ou pacotes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (valor) {
                setState(() {
                  _filtroBusca = valor;
                });
              },
            ),
          ),

          // Banner de Destaque Interativo (Carrossel com as 3 imagens)
          SizedBox(
            height: 240,
            child: PageView.builder(
              itemCount: _destinos.length,
              onPageChanged: (index) {
                setState(() {
                  _indiceAtual = index;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _mostrarMensagem(
                      'Detalhes de: ${_destinos[index]['titulo']}'),
                  child: Image.asset(
                    _destinos[index]['imagem']!,
                    width: 600,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          titleSection,
          buttonSection,
          textSection,
        ],
      ),
    );
  }
}