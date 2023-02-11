import SwiftUI

struct DataRow: Identifiable {
    public let id: Double
    public let values: [Double]
}

struct DataTable: NSViewRepresentable {
    @Binding var headers: [String]
    @Binding var data: [DataRow]

    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        let headers: [String]
        let data: [DataRow]

        init(headers: [String], data: [DataRow]) {
            self.headers = headers
            self.data = data
        }

        func numberOfRows(in tableView: NSTableView) -> Int {
            data.count
        }

        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let identifier = tableColumn!.identifier.rawValue
            let item: String
            if identifier == "index" {
                item = String(format: "%.0f", data[row].id)
            } else {
                let index = Int(identifier)!
                item = String(format: "%.6f", data[row].values[index])
            }
            let text = NSTextField(labelWithString: String(item))
            text.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
            let rowHeight = tableColumn!.tableView!.rowHeight
            let colWidth = tableColumn!.width
            let textHeight = text.sizeThatFits(NSSize(width: 100, height: 100)).height
            text.frame = .init(x: 0, y: rowHeight / 2 - textHeight / 2, width: colWidth, height: textHeight)
            let ps = NSMutableParagraphStyle()
            ps.alignment = .right
            let string = NSAttributedString(string: String(item), attributes: [.paragraphStyle: ps])
            text.attributedStringValue = string
            let cell = NSTableCellView()
            cell.addSubview(text)
            return cell
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(headers: headers, data: data)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let tableView = NSTableView()
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        
        if let numColumns = data.first?.values.count {
            for i in 0..<numColumns+1 {
                let header = headers[i]
                let identifier: String
                if i == 0 {
                    identifier = "index"
                } else {
                    identifier = String(i - 1)
                }
                let column = NSTableColumn(identifier: .init(identifier))
                column.title = header
                column.resizingMask = .autoresizingMask
                column.width = identifier == "index" ? 30 : 100
                column.maxWidth = identifier == "index" ? 30 : 100
                column.headerCell.alignment = .right
                tableView.addTableColumn(column)
            }
        }

        let scrollView = NSScrollView()
        scrollView.documentView = tableView
        
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
    }
}

struct ContentView: View {
    @State var headers = ["", "First", "Second"]
    @State var data = [DataRow(id: 0, values: [0.718002, -2.461276]),
                       DataRow(id: 1, values: [0.242800, -0.670200]),
                       DataRow(id: 2, values: [0.087668, 0.020849]),
                       DataRow(id: 3, values: [-0.832850, -0.294953]),
                       DataRow(id: 4, values: [0.409674, 0.158862])]
    var body: some View {
        DataTable(headers: $headers, data: $data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
