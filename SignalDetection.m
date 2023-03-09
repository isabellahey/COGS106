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
        
        methods (Static)
        function sdtList = simulate(dprime,criteriaList,signalCount,noiseCount)
         
         k = criterionList + (dprime/2);
            hits_p = 1 - normcdf(k - dprime);
            falsealarms_p = 1 - normcdf(k);
            sdtList = zeros(size(SignalDetection));

            for i = 1:length(criteriaList)
                hits = binornd(hits_p, signalCount);
                misses = normcdf(k-dprime);
                falseAlarms = bionrnd(falsealarms_p, noiseCount);
                correctRejections = normcdf(k);
                sdtList(i) = SignalDetection(hits, misses, falseAlarms, correctRejections);
            end
        end
    end
end           
