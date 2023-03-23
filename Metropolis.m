classdef Metropolis
    properties
        samples
    end
    
    properties (Access = private)
        logTarget
        state
        sigma
        accProb
    end
    
    methods
        function obj = Metropolis(logTarget, initialState)
            obj.logTarget = logTarget;
            obj.state = initialState;
            obj.sigma = 1;
            obj.accProb = 0;
            obj.samples = [];
        end
    end
        
        methods (Access = private)
        function yesno = accept(obj, proposal)
            logAccProb = obj.logTarget(proposal) - obj.logTarget(obj.state);
            if logAccProb >= 0
                yesno = true;
            else
                accProb = exp(logAccProb);
                if rand < accProb
                    yesno = true;
                else
                    yesno = flase;
                end
            end
            obj.accProb = (obj.accProb + yesno) / 2;
        
        function obj = adapt(obj, blockLengths)
            targetAcceptRate = 0.4;
            nBlocks = length(blockLengths);
            acceptRates = zeros(1, nBlocks);
            for i = 1:nBlocks
                for j = 1:blockLengths(i)
                    proposal = obj.state + obj.sigma * randn();
                    obj.accept(proposal);
                end
                acceptRates(i) = mean(acceptances);
            end
            meanAcceptRate = mean(acceptRates);
            adjFactor = meanAcceptRate / targetAcceptRate;
            if adjFactor > 1.2
                obj.sigma = obj.sigma / adjFactor;
            elseif adjFactor < 0.8
                obj.sigma = obj.sigma * adjFactor;
            end
        end
        
        function obj = sample(obj, n)
            obj.samples = zeros(1, n);
            for i = 1:n
                proposal = normrnd(obj.state, obj.sigma);
                if obj.accept(proposal)
                obj.state = proposal;
                end
                obj.samples(i) = obj.state;
            end
        end
        
        function summ = summary(obj)
            meanVal = mean(obj.samples);
            ci = prctile(obj.samples, [2.5, 97.5]);
            summ.mean = meanVal;
            summ.ci = ci;
            summ.c25 = ci(1);
            summ.c975 = ci(2);
        end
     end
  end
end
