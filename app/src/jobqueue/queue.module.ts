import { Inject, Module, OnModuleInit } from '@nestjs/common';
import { createWorkers } from '../workers/zscore.main';
import { ZscoreJobQueue } from './queue/zscore.queue';
import { NatsModule } from '../nats/nats.module';
import { JobCompletedPublisher } from '../nats/publishers/job-completed-publisher';

@Module({
  imports: [NatsModule],
  providers: [ZscoreJobQueue],
  exports: [ZscoreJobQueue],
})
export class QueueModule implements OnModuleInit {
  @Inject(JobCompletedPublisher) jobCompletedPublisher: JobCompletedPublisher;
  async onModuleInit() {
    await createWorkers(this.jobCompletedPublisher);
  }
}
