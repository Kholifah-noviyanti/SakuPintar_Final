import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SakuPintar UAS',
      home: SakuPintarUAS(),
    ),
  );
}

class SakuPintarUAS extends StatefulWidget {
  const SakuPintarUAS({super.key});

  @override
  State<SakuPintarUAS> createState() => _SakuPintarUASState();
}

class _SakuPintarUASState extends State<SakuPintarUAS> {
  // Variabel untuk menyimpan data profil agar bisa diganti-ganti
  String _namaUser = "Siti Kholifah Noviyanti";
  String _nomorUser = "20241220035";

  final List<Map<String, dynamic>> _transaksi = [
    {'id': '1', 'judul': 'Saldo Utama', 'jumlah': 2500000, 'tipe': 'masuk'},
  ];

  final _judulController = TextEditingController();
  final _jumlahController = TextEditingController();

  int get _totalSaldo {
    int saldo = 0;
    for (var item in _transaksi) {
      if (item['tipe'] == 'masuk') {
        saldo += item['jumlah'] as int;
      } else {
        saldo -= item['jumlah'] as int;
      }
    }
    return saldo;
  }

  // Halaman Profil yang bisa diedit oleh pengguna lain
  void _showProfile() {
    final _nameEditController = TextEditingController(text: _namaUser);
    final _idEditController = TextEditingController(text: _nomorUser);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Profil Pengguna", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF1A237E),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _nameEditController,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                hintText: "Masukkan nama Anda",
              ),
            ),
            TextField(
              controller: _idEditController,
              decoration: const InputDecoration(
                labelText: "NPM / Nomor ID",
                hintText: "Masukkan nomor identitas",
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _namaUser = _nameEditController.text;
                _nomorUser = _idEditController.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
            ),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _tambahData() {
    final String judul = _judulController.text;
    final int? jumlah = int.tryParse(_jumlahController.text);
    if (judul.isNotEmpty && jumlah != null && jumlah > 0) {
      setState(() {
        _transaksi.add({
          'id': DateTime.now().toString(),
          'judul': judul,
          'jumlah': jumlah,
          'tipe': 'keluar',
        });
      });
      _judulController.clear();
      _jumlahController.clear();
      Navigator.pop(context);
    }
  }

  void _editSaldoUtama(String id, int jumlahLama) {
    _jumlahController.text = jumlahLama.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Saldo Utama"),
        content: TextField(
          controller: _jumlahController,
          decoration: const InputDecoration(labelText: "Masukkan Saldo Baru"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final int? newJumlah = int.tryParse(_jumlahController.text);
              if (newJumlah != null) {
                setState(() {
                  _transaksi.firstWhere((item) => item['id'] == id)['jumlah'] =
                      newJumlah;
                });
                _jumlahController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "SakuPintar UAS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showProfile,
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A237E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Saldo Anda",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rp ${NumberFormat('#,###', 'id_ID').format(_totalSaldo)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transaksi.length,
              itemBuilder: (context, index) {
                final item = _transaksi[index];
                final isSaldoUtama = item['judul'] == 'Saldo Utama';
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSaldoUtama ? Colors.blue : Colors.red,
                      child: Icon(
                        isSaldoUtama
                            ? Icons.account_balance
                            : Icons.shopping_bag,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      item['judul'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Rp ${NumberFormat('#,###', 'id_ID').format(item['jumlah'])}",
                          style: TextStyle(
                            color: isSaldoUtama ? Colors.blue : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isSaldoUtama)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _editSaldoUtama(item['id'], item['jumlah']),
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                setState(() => _transaksi.removeAt(index)),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Tambah Pengeluaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _judulController,
                    decoration: const InputDecoration(
                      labelText: "Nama Pengeluaran",
                    ),
                  ),
                  TextField(
                    controller: _jumlahController,
                    decoration: const InputDecoration(labelText: "Nominal"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _tambahData,
                    child: const Text("Simpan"),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
