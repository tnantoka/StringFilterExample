import Vapor
import Fluent
import Foundation
import StringFilter

struct ExclaimFilter: StringFilterType {
    func transform(_ string: String) -> String {
        return string + "!"
    }
}


final class Example: Model {
    var id: Node?
    var exists: Bool = false
    
    var name: String
    var input: String
    var output: String {
        guard let filter = Example.filters[name] else { return "" }
        return input.str_filter(filter.0)
    }
    
    init(name: String, input: String) {
        self.id = UUID().uuidString.makeNode()
        self.name = name
        self.input = input
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        input = try node.extract("input")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "input": input,
            "output": output
        ])
    }
    
    static var filters: [String: (StringFilterType, String)] = [
        ".capitalize" : (StringFilter.capitalize, "test"),
        ".lowercase" : (StringFilter.lowercase, "TEST"),
        ".uppercase" : (StringFilter.uppercase, "test"),
        ".shift(1)" : (StringFilter.shift(1), "test"),
        ".repeat(2)" : (StringFilter.repeat(2), "test"),
        ".replace(\"t\", \"T\")" : (StringFilter.replace("t", "T"), "test"),
        ".japanese(.hiragana, .katakana)" : (StringFilter.japanese(.hiragana, .katakana), "あいうえお"),
        ".japanese(.katakana, .hiragana)" : (StringFilter.japanese(.katakana, .hiragana), "アイウエオ"),
        ".japanese(.full(.alphabet), .half(.alphabet))" : (StringFilter.japanese(.full(.alphabet), .half(.alphabet)), "ＡＢＣＤＥ"),
        ".japanese(.half(.alphabet), .full(.alphabet))" : (StringFilter.japanese(.half(.alphabet), .full(.alphabet)), "ABCDE"),
        ".japanese(.full(.number), .half(.number))" : (StringFilter.japanese(.full(.number), .half(.number)), "０１２３４５６７８９"),
        ".japanese(.half(.number), .full(.number))" : (StringFilter.japanese(.half(.number), .full(.number)), "0123456789"),
        ".japanese(.full(.katakana), .half(.katakana))" : (StringFilter.japanese(.full(.katakana), .half(.katakana)), "アイウエオ"),
        ".japanese(.half(.katakana), .full(.katakana))" : (StringFilter.japanese(.half(.katakana), .full(.katakana)), "ｱｲｳｴｵ"),
        "ExclaimFilter() * 3" : (ExclaimFilter() * 3, "Hello"),
    ]
}

extension Example: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }

    static func revert(_ database: Database) throws {
        //
    }
}
