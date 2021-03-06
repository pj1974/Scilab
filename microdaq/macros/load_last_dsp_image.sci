function load_last_dsp_image()
    global %microdaq;
    if isfile(TMPDIR + filesep() + "last_mdaq_dsp_image") == %t then
        dsp_app_path = mgetl(TMPDIR + filesep() + "last_mdaq_dsp_image");
        if isfile(dsp_app_path) == %t then
            connection_id = mdaq_open();
            if connection_id < 0 then
                message('Unable to locate MicroDAQ device - check your setup!');
                return;
            end

            disp('### Loading model to MicroDAQ...');
            res = mdaq_dsp_load(connection_id, dsp_app_path, '');
            if res < 0 then
                // try again to load application
                mdaq_close(connection_id);
                connection_id = mdaq_open();
                if connection_id < 0 then
                    message('ERROR: Unable to locate MicroDAQ device - check your setup!');
                    return;
                end
                res = mdaq_dsp_load(connection_id, dsp_app_path, '');
                if res < 0 then
                    message('Unable to load DSP firmware!');
                    mdaq_close(connection_id);
                    %microdaq.dsp_loaded = %F
                    return;
                end
            end

            disp('### Starting model on MicroDAQ...');
            res = mdaq_dsp_start(connection_id);
            if res < 0 then
                message("Unable to start DSP application!");
                mdaq_close(connection_id);
                %microdaq.dsp_loaded = %F;
                return;
            end
            %microdaq.dsp_loaded = %T;

        else
            message("Unable to find model, build model and try again!")
        end
    else
        message("Unable to find model, build model and try again!")
    end
endfunction
