// Class fifo_scoreboard
//
class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    // Porta de análise para receber dados do monitor
    uvm_analysis_imp #(fifo_item, fifo_scoreboard) item_export;

    // Fila para armazenar os dados esperados
    mailbox #(fifo_item) expected_data;
    mailbox #(fifo_item) received_data;

    int error_count = 0;
    int total_checked = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_export = new("item_export", this);
        expected_data = new();
        received_data = new();
    endfunction: new

    // Função chamada quando um monitor envia uma transação
    function void write(fifo_item item);
        if (item.rd_en) begin
            received_data.put(item);
        end
        if (item.wr_en) begin
            expected_data.put(item);
        end
    endfunction: write

    // Lógica de comparação entre enviado e recebido
    task run_phase(uvm_phase phase);
        fifo_item exp_item;
        fifo_item rec_item;
        super.run_phase(phase);

        forever begin
            // Espera itens em ambos os mailboxes
            expected_data.get(exp_item);
            received_data.get(rec_item);
            total_checked++;

            //Verificação básica
            if (exp_item.din !== rec_item.dout) begin
                error_count++;
                `uvm_error("SCOREBOARD", $sformatf("Data mismatch: \nExpected: %h\nReceived: %h",
                    exp_item.din, rec_item.dout))
            end

             // Verificação de status
            if (rec_item.full && exp_item.wr_en)
                `uvm_warning("SCOREBOARD", "Write attempted when FIFO was full")
                
            if (rec_item.empty && exp_item.rd_en)
                `uvm_warning("SCOREBOARD", "Read attempted when FIFO was empty")
        end
    endtask: run_phase

endclass: fifo_scoreboard
