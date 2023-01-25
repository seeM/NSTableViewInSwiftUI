import SwiftUI

struct TableView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSTableView {
        let tableView = NSTableView()
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator

        let column = NSTableColumn()
        column.identifier = NSUserInterfaceItemIdentifier("name")
        tableView.addTableColumn(column)

        return tableView
    }

    func updateNSView(_ nsView: NSTableView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        let data = ["Apple", "Banana", "Cherry"]

        func numberOfRows(in tableView: NSTableView) -> Int {
            return data.count
        }

        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let rowData = data[row]
            let id = NSUserInterfaceItemIdentifier(rawValue: "cell")
            let text = NSTextField(labelWithString: rowData)
            let view = NSTableCellView()
            view.identifier = id
            view.addSubview(text)
            return view
        }
    }
}

struct ContentView: View {
    var body: some View {
        TableView()
            .padding(.bottom)
            .frame(width: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
