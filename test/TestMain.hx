class TestMain {
	static function main() {
		utest.UTest.run([
			new TweenTest(),
			new UpdateTest(),
		]);
	}
}
