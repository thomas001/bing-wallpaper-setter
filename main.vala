using Gtk;

class Foo {
	public async void check() {
		BingSource bing = new BingSource();
		Wallpaper[] wallpapers = yield bing.list_wallpapers();
		stdout.printf("%i\n",wallpapers.length);
		foreach(var wallpaper in wallpapers) {
			stdout.printf("%s\n", wallpaper.get_name());
		}
		Gtk.main_quit();
	}
}

int main(string[] args) {
	Gtk.init(ref args);

	var f = new Foo();
	f.check.begin();
	Gtk.main();
	return 0;
}
