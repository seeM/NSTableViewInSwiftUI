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
            let item: Double
            if identifier == "index" {
                item = data[row].id
            } else {
                let index = Int(identifier)!
                item = data[row].values[index]
            }
            let text = NSTextField(labelWithString: String(item))
            let rowHeight = tableColumn!.tableView!.rowHeight
            let colWidth = tableColumn!.width
            let textHeight = text.sizeThatFits(NSSize(width: 100, height: 100)).height
            text.frame = .init(x: 0.0, y: rowHeight / 2 - textHeight / 2, width: colWidth, height: textHeight)
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
                tableView.addTableColumn(column)
                print("Index:", i)
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
