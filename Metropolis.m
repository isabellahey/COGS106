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
        
        function self = adapt(self, blockLengths)
            nBlocks = length(blockLengths);
            acceptRates = zeros(1, nBlocks);
            for i = 1:nBlocks
                acceptances = zeros(1, blocklengths(i));
                for j = 1:blockLengths(i)
                    proposal = self.state + self.sigma * randn();
                    if self.accept(proposal);
                    self.state = proposal;
                    acceptances(j) = 1;
                end
            end 
                acceptRates(i) = mean(acceptances);
            end
            meanAcceptRate = mean(acceptRates);
            targetAcceptRate = 0.4;
            adjFactor = meanAcceptRate / targetAcceptRate;
            if adjFactor > 1.2
                self.sigma = self.sigma / adjFactor;
            elseif adjFactor < 0.8
                self.sigma = self.sigma * adjFactor;
            end
        end
        
        function yesno = accept(self, proposal)
            logRatio = self.logTarget(proposal) - self.logTarget(obj.state);
            if log(rand()) < logRatio
                yesno = true;
                self.accProb = self.accProb + 1;
            else
                yesno = flase;
            end
        end
        
        function self = sample(self, n)
            self.samples = zeros(1, n);
            for i = 1:n
                proposal = normrnd(self.state, self.sigma);
                if self.accept(proposal)
                self.state = proposal;
                end
                self.samples(i) = self.state;
            end
        end
        
        function summ = summary(obj)
            meanVal = mean(self.samples);
            ci = prctile(self.samples, [2.5, 97.5]);
            summ.mean = meanVal;
            summ.ci = ci;
            summ.c25 = ci(1);
            summ.c975 = ci(2);
        end
     end
  end
