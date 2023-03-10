classdef SignalDetection
    properties
        hits
        misses
        falseAlarms
        correctRejections
    end

    methods
        function obj = SignalDetection(hits,misses,falseAlarms,correctRejections)
            obj.hits=hits;
            obj.misses=misses;
            obj.falseAlarms=falseAlarms;
            obj.correctRejections=correctRejections;
        end

        function hits_rate = hits_rate(obj)
            hits_rate = obj.hits / (obj.hits + obj.misses);
        end
        
        function falsealarms_rate = falsealarms_rate(obj)
            falsealarms_rate = obj.falseAlarms / (obj.falseAlarms + obj.correctRejections);
        end
        function d_prime = d_prime(obj)
            d_prime = norminv(obj.hits_rate) - norminv(obj.falsealarms_rate);
        end

        function criterion = criterion(obj)
            criterion = -0.5 * (norminv(obj.hits_rate) + norminv(obj.falsealarms_rate));
        end
        
        %% Operator Overloading
        function Total = plus(objx,objy)
            Total = SignalDetection(objx.hits + objy.hits, objx.misses + objy.misses, objx.falseAlarms + objy.falseAlarms, ...
                objx.correctRejections + objy.correctRejections);
        end
        
        function Multiplied = mtimes(obj, k)
            Multiplied = SignalDetection(obj.hits .* k, obj.misses .* k, obj.falseAlarms .* k, ...
                obj.correctRejections .* k);
        end
        
          %% Plots
        function plot_roc = plot_roc(obj)
            x= [0,obj.falsealarms_rate,1];
            y= [0,obj.hits_rate,1];
            plot(x,y)
            xlabel('False Alarm Rate')
            ylabel('Hit Rate')
            xlim([0,1])
            ylim([0,1])
            title('ROC Curve')
        end
          function plot_sdt = plot_sdt(obj)
            z= [-6:.2:6];
            Noise= normpdf(z,0,1);
            Signal= normpdf(z,obj.d_prime,1);
            plot(z,Noise,z, Signal)
            line([0 obj.d_prime],[max(Noise), max(Signal)])
            xline((obj.d_prime/2) + obj.criterion, 'k-')
            xlabel('Signal Strength')
            ylabel('Probability of Occurence')
            legend('Noise','Signal')
            title('SDT PLot')
        end
        
            function ell = nLogLikelihood(obj, hitRate, falseAlarmsRate)
            ell = -obj.hits*log(hitRate) - obj.misses*log(1 - hitRate)...
                - obj.falseAlarms* log(falseAlarmsRate)...
                - obj.correctRejections* log(1 - falseAlarmsRate);
    end
end
        
        methods (Static)
        
           function sdtList = simulate(dprime,criteriaList,signalCount,noiseCount)
         
             sdtList = [];
            for i = 1:length(criteriaList)
                k = criteriaList(i) + (dprime/2);
                hits_p = 1 - normcdf(k - dprime);
                falsealarms_p = normcdf(k);

                hits = binornd(signalCount, hits_p);
                misses = signalCount - hits;
                falseAlarms = binornd(noiseCount, falsealarms_p);
                correctRejections = noiseCount - falseAlarms;
                sdtList = [sdtList; SignalDetection(hits, misses, falseAlarms, correctRejections)];
            end
        end
        
         function plot_Roc = plot_Roc(sdtList)
            hold on;
            for i = 1:length(sdtList)
                x = sdtList(i).falsealarms_rate();
                y= sdtList(i).hits_rate();
            end
            line([0,1], [0,1], 'LineStyle', '-');
            grid on
            hold off;
            xlim([0,1])
            ylim([0,1])
            xlabel('false alarm rate')
            ylabel('hit rate')
            title('ROC curve')
        end
    end
end           
