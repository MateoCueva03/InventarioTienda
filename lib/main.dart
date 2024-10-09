import 'package:flutter/material.dart';

//------------------------------------------------------------
void main() {
  runApp(MyApp());
}

class Producto {
  String nombre;
  double precio;
  int cantidad;
  String categoria;

  Producto(this.nombre, this.precio, this.cantidad, this.categoria);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Inventario',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InventarioScreen(),
    );
  }
}

class InventarioScreen extends StatefulWidget {
  @override
  _InventarioScreenState createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  List<Producto> productos = [];

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController buscarController = TextEditingController();
  final TextEditingController actualizarNombreController =
      TextEditingController();
  final TextEditingController actualizarCantidadController =
      TextEditingController();
  final TextEditingController categoriaBuscarController =
      TextEditingController();

  // Agregar nuevo producto
  void agregarProducto() {
    setState(() {
      String nombre = nombreController.text;
      double precio = double.tryParse(precioController.text) ?? 0.0;
      int cantidad = int.tryParse(cantidadController.text) ?? 0;
      String categoria = categoriaController.text;

      productos.add(Producto(nombre, precio, cantidad, categoria));

      nombreController.clear();
      precioController.clear();
      cantidadController.clear();
      categoriaController.clear();
    });
  }

  // Buscar producto por nombre o categoría
  List<Producto> buscarProducto(String busqueda) {
    return productos
        .where((producto) =>
            producto.nombre.toLowerCase().contains(busqueda.toLowerCase()) ||
            producto.categoria.toLowerCase().contains(busqueda.toLowerCase()))
        .toList();
  }

  // Actualizar la cantidad de un producto
  void actualizarCantidad(String nombre, int nuevaCantidad) {
    setState(() {
      for (var producto in productos) {
        if (producto.nombre.toLowerCase() == nombre.toLowerCase()) {
          producto.cantidad = nuevaCantidad;
        }
      }
    });
  }

  // Calcular el valor total del inventario
  double valorTotalInventario() {
    double total = 0;
    for (var producto in productos) {
      total += producto.precio * producto.cantidad;
    }
    return total;
  }

  // Mostrar productos por categoría
  List<Producto> mostrarProductosPorCategoria(String categoria) {
    return productos
        .where((producto) =>
            producto.categoria.toLowerCase() == categoria.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Inventario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Producto'),
            ),
            TextField(
              controller: precioController,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: cantidadController,
              decoration: InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: categoriaController,
              decoration: InputDecoration(labelText: 'Categoría'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: agregarProducto,
              child: Text('Agregar Producto'),
            ),
            TextField(
              controller: buscarController,
              decoration:
                  InputDecoration(labelText: 'Buscar por Nombre o Categoría'),
            ),
            ElevatedButton(
              onPressed: () {
                String busqueda = buscarController.text;
                List<Producto> resultados = buscarProducto(busqueda);
                if (resultados.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Resultados de Búsqueda'),
                        content: Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount: resultados.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(resultados[index].nombre),
                                subtitle: Text(
                                    'Precio: \$${resultados[index].precio}, Cantidad: ${resultados[index].cantidad}, Categoría: ${resultados[index].categoria}'),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Buscar Producto'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: actualizarNombreController,
              decoration: InputDecoration(
                  labelText: 'Nombre del Producto a Actualizar'),
            ),
            TextField(
              controller: actualizarCantidadController,
              decoration: InputDecoration(labelText: 'Nueva Cantidad'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                String nombre = actualizarNombreController.text;
                int nuevaCantidad =
                    int.tryParse(actualizarCantidadController.text) ?? 0;
                actualizarCantidad(nombre, nuevaCantidad);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Actualización Exitosa'),
                      content: Text(
                          'Cantidad de $nombre actualizada a $nuevaCantidad.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cerrar'),
                        )
                      ],
                    );
                  },
                );
                actualizarNombreController.clear();
                actualizarCantidadController.clear();
              },
              child: Text('Actualizar Cantidad de Producto'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoriaBuscarController,
              decoration:
                  InputDecoration(labelText: 'Mostrar Productos por Categoría'),
            ),
            ElevatedButton(
              onPressed: () {
                String categoria = categoriaBuscarController.text;
                List<Producto> productosCategoria =
                    mostrarProductosPorCategoria(categoria);
                if (productosCategoria.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Productos en Categoría: $categoria'),
                        content: Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount: productosCategoria.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(productosCategoria[index].nombre),
                                subtitle: Text(
                                    'Precio: \$${productosCategoria[index].precio}, Cantidad: ${productosCategoria[index].cantidad}'),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
                          )
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Mostrar Productos por Categoría'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                double total = valorTotalInventario();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Valor Total del Inventario'),
                      content: Text('Total: \$${total.toStringAsFixed(2)}'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cerrar'),
                        )
                      ],
                    );
                  },
                );
              },
              child: Text('Calcular Valor Total del Inventario'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return ListTile(
                    title: Text(producto.nombre),
                    subtitle: Text(
                        'Precio: \$${producto.precio}, Cantidad: ${producto.cantidad}, Categoría: ${producto.categoria}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
