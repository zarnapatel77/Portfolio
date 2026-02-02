import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Modi Vraj Portfolio",
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ).copyWith(
          primary: Colors.indigo,
          secondary: Colors.deepPurpleAccent,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const PortfolioScreen(),
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  String activeSection = "Home"; // track highlighted section

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double getOffset(GlobalKey key) {
      final context = key.currentContext;
      if (context == null) return double.infinity;
      final box = context.findRenderObject() as RenderBox;
      return box.localToGlobal(Offset.zero).dy;
    }

    double homePos = getOffset(homeKey);
    double aboutPos = getOffset(aboutKey);
    double projectsPos = getOffset(projectsKey);
    double contactPos = getOffset(contactKey);

    String newSection = activeSection;

    if (contactPos <= MediaQuery.of(context).size.height / 2 ||
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50) {
      newSection = "Contact";
    } else if (projectsPos <= 150) {
      newSection = "Projects";
    } else if (aboutPos <= 150) {
      newSection = "About";
    } else {
      newSection = "Home";
    }

    if (newSection != activeSection) {
      setState(() {
        activeSection = newSection;
      });
    }
  }

  void _scrollToSection(GlobalKey key, String section) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
    setState(() {
      activeSection = section;
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vraj Modi Portfolio"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black26,
        actions: isMobile
            ? null
            : [
          navButton("Home", () => _scrollToSection(aboutKey, "Home")),
          navButton("About", () => _scrollToSection(aboutKey, "About")),
          navButton("Projects", () => _scrollToSection(projectsKey, "Projects")),
          navButton("Contact", () => _scrollToSection(contactKey, "Contact")),
          const SizedBox(width: 20),
        ],
      ),
      drawer: isMobile
          ? Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Modi Vraj"),
              accountEmail: Text("vrajmodi736@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.indigo),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.deepPurpleAccent],
                ),
              ),
            ),
            drawerItem("Home", Icons.home, () {_scrollToSection(homeKey, "Home"); Navigator.of(context).pop();} ),
            drawerItem("About", Icons.info, ()  {_scrollToSection(aboutKey, "About"); Navigator.of(context).pop();} ),
            drawerItem("Projects", Icons.work, () {_scrollToSection(projectsKey, "Project"); Navigator.of(context).pop();} ),
            drawerItem("Contact", Icons.contact_mail, () {_scrollToSection(contactKey, "Contact"); Navigator.of(context).pop();} ),
          ],
        ),
      )
          : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HOME ----------
            sectionContainer(
              key: homeKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(''),
                    ),
                    const SizedBox(height: 20),
                    Text("Hello, I'm Vraj Modi👩‍💻",
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    const Text(
                      "Wordpress | Shopify Developer",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // ---------- ABOUT ----------
            sectionContainer(
              key: aboutKey,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About Me",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(
                      "I have completed Diploma Information Technology(IT) in Silver Oak University."
                          "I completed Schooling from Vidhya Nagar High School"
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Intership",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("I have completed Web Development Internship in Dev Opus Pvt. Ltd."
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Experience",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("I have 1.5 Years Experience WordPress & Shopify Developer."),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Skills",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                ],
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 5,
                    children: [
                      Chip(label: Text("Leadership")),
                      Chip(label: Text("Creativity")),
                      Chip(label: Text("Shopify Developer")),
                      Chip(label: Text("Wordpress Developer")),
                      Chip(label: Text("Management Skills")),
                    ],
                  ),
                ),
              ],
            ),


            // ---------- PROJECTS ----------
            sectionContainer(
              key: projectsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Projects",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  projectTile(
                    "Bezelis",
                    "Diamond Accessories Selling Brand Website",
                    "https://bezelis.com/",
                  ),
                  projectTile(
                    "Dabstitch",
                    "Clothing Brand Shopping Website",
                    "https://dabstitch.com",
                  ),
                  projectTile(
                    "Dattu Dry Fruits",
                    "Dry Fruits E-Commerce Website",
                    "https://dattudryfruits.com/",
                  ),
                ],
              ),
            ),

            // ---------- CONTACT ----------
            sectionContainer(
              key: contactKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Contact Me",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  magicButton("📧 Email", "mailto:vrajmodi736@gmail.com"),
                  const SizedBox(height: 5),
                  magicButton("🔗 LinkedIn", "https://www.linkedin.com/in/vraj-modi-b3468a35b?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app"),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const Center(
              child: Text(
                "© 2025 Modi Vraj ",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- WIDGET HELPERS ----------

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  // INFO TILE WIDGET
  Widget infoTile(String title, String subtitle) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: const Icon(Icons.arrow_right),
      ),
    );
  }




  Widget sectionContainer({required Widget child, Key? key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: child,
    );
  }

  Widget navButton(String title, VoidCallback onTap) {
    bool isHovered = false;
    bool isActive = (activeSection == title);

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: TextButton(
            onPressed: onTap,
            child: Text(
              title,
              style: TextStyle(
                color: isActive
                    ? Colors.yellow
                    : (isHovered ? Colors.yellow.shade200 : Colors.white),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: isActive ? 18 : 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget drawerItem(String title, IconData icon, VoidCallback onTap) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isHovered ? Colors.indigo.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(icon,
                  color: isHovered ? Colors.indigo : Colors.grey.shade700),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isHovered ? Colors.indigo : Colors.black87,
                  fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }

  Widget projectTile(String title, String desc, String url) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.code_rounded, color: Colors.indigo),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(desc, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final Uri uri = Uri.parse(url);
                  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                    throw Exception("Could not launch $url");
                  }
                },
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text("View Project"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget magicButton(String title, String url) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isHovered ? 1.05 : 1.0,
            child: ElevatedButton(
              onPressed: () async {
                final Uri uri = Uri.parse(url);
                if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                  throw Exception("Could not launch $url");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isHovered ? Colors.deepPurpleAccent : Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                elevation: isHovered ? 6 : 2,
              ),
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
          ),
        );
      },
    );
  }
}
