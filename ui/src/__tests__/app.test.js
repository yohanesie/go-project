import { describe, it, expect } from 'vitest'

describe('App basic tests', () => {
  it('should pass basic arithmetic', () => {
    expect(1 + 1).toBe(2)
  })

  it('should validate string operations', () => {
    const appName = 'go-project'
    expect(appName).toContain('go')
    expect(appName.length).toBeGreaterThan(0)
  })

  it('should handle array operations', () => {
    const items = ['backend', 'frontend', 'database']
    expect(items).toHaveLength(3)
    expect(items).toContain('backend')
  })
})
