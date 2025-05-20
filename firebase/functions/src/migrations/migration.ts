export class Migration {
  constructor(
        public migrationNumber: number,
        public description: string,
        public appVersion: string,
        public createdAt: Date,
  ) {}
    
  static empty(): Migration {
    return new Migration(0, 'Initial Migration', '1.0.0', new Date());
  };
    
  async run() {
    throw new Error('Not implemented');
  }
    
  toJson() {
    return {
      migrationNumber: this.migrationNumber,
      description: this.description,
      appVersion: this.appVersion,
      createdAt: this.createdAt,
    };
  }
}
