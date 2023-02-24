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
    end
end           
