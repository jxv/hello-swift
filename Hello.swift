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

func run(args: [String], clock: Clock, emit: (String) -> (), fileSystem: FileSystem) {
    let start = clock.now()
    let target = fileSystem.readFile(fileName: CommandLine.arguments[1])
    let target2 = String(target.dropLast()) // Drops trailing newline
    emit("Hello, " + target2 + "!")
    let end = clock.now()
    let duration = diffTimeInterval(start: start, end: end)
    emit(String(duration * 1000) + "ms")
}

// Main

func main() {
    let clock = ClockImpl()
    let console = ConsoleImpl()
    let emitter = EmitterImpl(console: console)
    let fileSystem = FileSystemImpl()
    let emit = emitter.emit(_:)
    run(args: CommandLine.arguments, clock: clock, emit: emit, fileSystem: fileSystem)
}

main()
