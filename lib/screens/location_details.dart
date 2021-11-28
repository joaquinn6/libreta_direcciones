import 'package:libreta_de_ubicaciones/providers/location_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class DetailLocation extends StatelessWidget {
  const DetailLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocalidadProvider>(context);
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.localidad!.nombre.toString()),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListTile(
                  title: SelectableText(provider.localidad!.nombre.toString()),
                  subtitle:
                      SelectableText(provider.localidad!.detalle.toString())),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Card(
                  elevation: 5.0,
                  child: SizedBox(
                      height: 400.0,
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(provider.localidad!.latitude!,
                              provider.localidad!.longitude!),
                          zoom: 15.0,
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                            attributionBuilder: (_) {
                              return Text("© OpenStreetMap contributors");
                            },
                          ),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: 90.0,
                                height: 90.0,
                                point: LatLng(provider.localidad!.latitude!,
                                    provider.localidad!.longitude!),
                                builder: (ctx) => Container(
                                  child: Icon(Icons.location_pin,
                                      color: Color(0xFF3C6448)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text(provider.localidad!.departamento! +
                    ' - ' +
                    provider.localidad!.municipio!),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 150.0,
        children: [
          ActionButton(
            onPressed: () => {
              launchWaze(
                  provider.localidad!.latitude, provider.localidad!.longitude),
            },
            tooltiptext: 'Waze',
            icon: Icon(Icons.directions_car_filled_outlined,
                color: (isDark)
                    ? Color.fromARGB(255, 0, 158, 158)
                    : Color.fromARGB(255, 100, 216, 224)),
          ),
          ActionButton(
            onPressed: () => {
              launchMaps(
                  provider.localidad!.latitude, provider.localidad!.longitude),
            },
            tooltiptext: 'Maps',
            icon: Icon(Icons.directions_car_filled_outlined,
                color: (isDark)
                    ? Color.fromARGB(255, 99, 226, 82)
                    : Color.fromARGB(255, 5, 109, 5)),
          ),
          ActionButton(
            onPressed: () => {
              launchMoovit(
                  provider.localidad!.latitude, provider.localidad!.longitude),
            },
            tooltiptext: 'Moovit',
            icon: Icon(Icons.directions_bus_filled_outlined,
                color: (isDark)
                    ? Color.fromARGB(255, 255, 130, 81)
                    : Color.fromARGB(255, 153, 58, 4)),
          ),
          ActionButton(
            onPressed: () => {
              provider.isEditing = true,
              Navigator.of(context).pushNamed("/form"),
            },
            tooltiptext: 'Editar',
            icon: Icon(Icons.edit_outlined,
                color: (isDark) ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }

  Future<void> launchWaze(double? lat, double? lng) async {
    var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  Future<void> launchMoovit(double? lat, double? lng) async {
    var url = 'moovit://nearby?lat=${lat.toString()}&lon=${lng.toString()}';
    var fallbackUrl = 'http://app.appsflyer.com/com.tranzmate?pid=DL&c=';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  Future<void> launchMaps(double? lat, double? lng) async {
    var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.menu),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
    String this.tooltiptext = '',
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String tooltiptext;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.iconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          tooltip: tooltiptext,
        ),
      ),
    );
  }
}
