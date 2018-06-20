import Foundation

// Contracts

protocol Console {
    func print(_ msg: String)
}

protocol FileSystem {
    func readFile(fileName: String) -> String
}

protocol Clock {
    func now() -> Date
}

protocol Emitter {
    func emit(_ msg: String)
}

// Implementations

class ConsoleImpl: Console {
    func print(_ msg: String) {
        Swift.print(msg) // `Swift.` references global function
    }
}

class FileSystemImpl: FileSystem {
    func readFile(fileName: String) -> String {
        let url = URL(fileURLWithPath: fileName)
        print(url.absoluteString)
        return try! String(contentsOf: url)
    }
}

class ClockImpl: Clock {
    func now() -> Date {
        return Date()
    }
}

class EmitterImpl: Emitter {
    let console: Console
    
    init(console: Console) {
        self.console = console
    }
    
    func emit(_ msg: String) {
        self.console.print(msg)
    }
}

// Util functions

func diffTimeInterval(start: Date, end: Date) -> TimeInterval {
    return end.timeIntervalSince1970 - start.timeIntervalSince1970
}

// Run

func run(args: [String], clock: Clock, emitter: Emitter, fileSystem: FileSystem) {
    let start = clock.now()
    let target = fileSystem.readFile(fileName: CommandLine.arguments[1])
    let target2 = String(target.dropLast()) // Drops trailing newline
    emitter.emit("Hello, " + target2 + "!")
    let end = clock.now()
    let duration = diffTimeInterval(start: start, end: end)
    emitter.emit(String(duration * 1000) + "ms")
}

// Main

func main() {
    let clock = ClockImpl()
    let console = ConsoleImpl()
    let emitter = EmitterImpl(console: console)
    let fileSystem = FileSystemImpl()
    run(args: CommandLine.arguments, clock: clock, emitter: emitter, fileSystem: fileSystem)
}

main()
