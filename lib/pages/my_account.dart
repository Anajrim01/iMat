      Consumer<UserManager>(
          builder: (context, userManager, child) {
          if (userManager.isLoggedIn) {
          return ElevatedButton.icon(
          onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyAccount()),
          );
        },
        icon: const Icon(Icons.account_circle, size: 24),
        label: const Text(
          'Mitt konto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC8E6C9),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AuthDialog();
            },
          );
        },
        icon: const Icon(Icons.person_outline, size: 24),
        label: const Text(
          'Logga in / Registrera',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF3E5F5),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
        ),
      );
    }
  },
),
